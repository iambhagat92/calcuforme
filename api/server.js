require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const slugify = require('slugify');
const sanitizeHtml = require('sanitize-html');

const User = require('./models/User');
const Post = require('./models/Post');

const app = express();
app.use(cors());
app.use(express.json({ limit: '1mb' }));
app.use(express.urlencoded({ extended: true }));

// Static for uploads (note: ephemeral on serverless)
const uploadsDir = path.join(process.cwd(), 'uploads');
if (!fs.existsSync(uploadsDir)) fs.mkdirSync(uploadsDir, { recursive: true });
app.use('/uploads', express.static(uploadsDir));

// DB connect
const MONGO = process.env.MONGO;
if (MONGO) {
  mongoose.connect(MONGO).then(()=>{
    console.log('Mongo connected');
  }).catch(err=>{
    console.error('Mongo connection error', err.message);
  });
}

// JWT helper
function auth(req, res, next){
  const hdr = req.headers.authorization || '';
  const token = hdr.startsWith('Bearer ') ? hdr.slice(7) : null;
  if(!token) return res.status(401).json({error:'Unauthorized'});
  try{
    const payload = jwt.verify(token, process.env.JWT_SECRET || 'secret');
    req.user = payload; next();
  }catch(e){ return res.status(401).json({error:'Invalid token'}); }
}

// Multer for uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) { cb(null, uploadsDir); },
  filename: function (req, file, cb) {
    const ext = path.extname(file.originalname);
    const name = slugify(path.basename(file.originalname, ext), { lower:true, strict:true });
    cb(null, `${name}-${Date.now()}${ext}`);
  }
});
function fileFilter(req, file, cb){
  if(/\.(png|jpe?g|webp|gif)$/i.test(file.originalname)) cb(null,true); else cb(new Error('Invalid file type'));
}
const upload = multer({ storage, fileFilter, limits: { fileSize: 2 * 1024 * 1024 } }); // 2MB

// Register
app.post('/api/register', async (req,res)=>{
  try{
    const {username, password} = req.body;
    if(!username || !password) return res.status(400).json({error:'username & password required'});
    const exists = await User.findOne({username});
    if(exists) return res.status(400).json({error:'User exists'});
    const hash = await bcrypt.hash(password, 10);
    const u = await User.create({username, passwordHash: hash, role:'admin'});
    return res.json({id: u._id, username: u.username});
  }catch(e){ res.status(500).json({error: e.message}); }
});

// Login
app.post('/api/login', async (req,res)=>{
  try{
    const {username, password} = req.body;
    const u = await User.findOne({username});
    if(!u) return res.status(401).json({error:'Invalid credentials'});
    const ok = await bcrypt.compare(password, u.passwordHash);
    if(!ok) return res.status(401).json({error:'Invalid credentials'});
    const token = jwt.sign({id: u._id, role: u.role, username: u.username}, process.env.JWT_SECRET || 'secret', {expiresIn:'7d'});
    res.json({token});
  }catch(e){ res.status(500).json({error: e.message}); }
});

// Upload
app.post('/api/upload', auth, upload.single('file'), (req,res)=>{
  try{
    const url = `/uploads/${req.file.filename}`;
    res.json({url});
  }catch(e){ res.status(400).json({error:e.message}); }
});

// Create Post
app.post('/api/posts', auth, async (req,res)=>{
  try{
    const { title, slug, content, excerpt, coverImage, tags, status, metaTitle, metaDescription, canonical } = req.body;
    if(!title || !content) return res.status(400).json({error:'title & content required'});
    const safeContent = sanitizeHtml(content, { allowedTags: sanitizeHtml.defaults.allowedTags.concat(['img','h1','h2','span']), allowedAttributes: { '*':['style','class','id'], 'img':['src','alt','title','width','height'] } });
    const s = (slug && slug.trim()) ? slugify(slug, {lower:true, strict:true}) : slugify(title, {lower:true, strict:true});
    const exists = await Post.findOne({slug: s});
    if(exists) return res.status(400).json({error:'slug exists'});
    const now = new Date();
    const post = await Post.create({
      title,
      slug: s,
      content: safeContent,
      excerpt: excerpt || String(sanitizeHtml(safeContent, {allowedTags:[], allowedAttributes:{}})).replace(/\s+/g,' ').slice(0,180),
      coverImage: coverImage || '',
      tags: Array.isArray(tags) ? tags : (typeof tags==='string' ? tags.split(',').map(t=>t.trim()).filter(Boolean) : []),
      status: status==='published' ? 'published' : 'draft',
      publishedAt: status==='published' ? now : undefined,
      metaTitle: metaTitle || '',
      metaDescription: metaDescription || '',
      canonical: canonical || ''
    });
    res.json(post);
  }catch(e){ res.status(500).json({error:e.message}); }
});

// List Posts
app.get('/api/posts', async (req,res)=>{
  try{
    const posts = await Post.find().sort({createdAt:-1});
    res.json(posts);
  }catch(e){ res.status(500).json({error:e.message}); }
});

// Get Post by id
app.get('/api/posts/:id', async (req,res)=>{
  try{
    const p = await Post.findById(req.params.id);
    if(!p) return res.status(404).json({error:'Not found'});
    res.json(p);
  }catch(e){ res.status(500).json({error:e.message}); }
});

// Update Post
app.put('/api/posts/:id', auth, async (req,res)=>{
  try{
    const { title, slug, content, excerpt, coverImage, tags, status, metaTitle, metaDescription, canonical } = req.body;
    const safeContent = content ? sanitizeHtml(content, { allowedTags: sanitizeHtml.defaults.allowedTags.concat(['img','h1','h2','span']), allowedAttributes: { '*':['style','class','id'], 'img':['src','alt','title','width','height'] } }) : undefined;
    const s = (slug && slug.trim()) ? slugify(slug, {lower:true, strict:true}) : undefined;
    const update = { updatedAt: new Date() };
    if(title!==undefined) update.title = title;
    if(safeContent!==undefined) update.content = safeContent;
    if(excerpt!==undefined) update.excerpt = excerpt;
    if(coverImage!==undefined) update.coverImage = coverImage;
    if(tags!==undefined) update.tags = Array.isArray(tags) ? tags : (typeof tags==='string' ? tags.split(',').map(t=>t.trim()).filter(Boolean) : []);
    if(status!==undefined) {
      update.status = status==='published' ? 'published' : 'draft';
      update.publishedAt = status==='published' ? new Date() : undefined;
    }
    if(metaTitle!==undefined) update.metaTitle = metaTitle;
    if(metaDescription!==undefined) update.metaDescription = metaDescription;
    if(canonical!==undefined) update.canonical = canonical;
    if(s!==undefined) {
      const exists = await Post.findOne({slug: s, _id: {$ne: req.params.id}});
      if(exists) return res.status(400).json({error:'slug exists'});
      update.slug = s;
    }
    const p = await Post.findByIdAndUpdate(req.params.id, update, {new:true});
    if(!p) return res.status(404).json({error:'Not found'});
    res.json(p);
  }catch(e){ res.status(500).json({error:e.message}); }
});

// Delete Post
app.delete('/api/posts/:id', auth, async (req,res)=>{
  try{
    const p = await Post.findByIdAndDelete(req.params.id);
    if(!p) return res.status(404).json({error:'Not found'});
    res.json({success:true});
  }catch(e){ res.status(500).json({error:e.message}); }
});

// Healthcheck
app.get('/api/health', (req,res)=>res.json({ok:true}));

// Export handler for Vercel serverless (wrap express)
module.exports = (req, res) => app(req, res);

// Also allow local run
if (require.main === module) {
  const PORT = process.env.PORT || 4000;
  app.listen(PORT, ()=>console.log('API running on '+PORT));
}
