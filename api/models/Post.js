const mongoose = require('mongoose');

const PostSchema = new mongoose.Schema({
  title: { type: String, required: true, trim: true },
  slug: { type: String, required: true, unique: true, trim: true },
  content: { type: String, required: true },
  excerpt: { type: String, default: '' },
  coverImage: { type: String, default: '' },
  tags: { type: [String], default: [] },
  status: { type: String, enum: ['draft', 'published'], default: 'draft' },
  publishedAt: { type: Date },
  metaTitle: { type: String, default: '' },
  metaDescription: { type: String, default: '' },
  canonical: { type: String, default: '' }
}, { timestamps: true });

module.exports = mongoose.model('Post', PostSchema);
