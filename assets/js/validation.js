document.querySelectorAll("input").forEach(el=>{
  if(el.type==="number"){
    el.addEventListener("blur",()=>{
      const v=parseFloat(el.value);
      if(isNaN(v)||v<=0){
        alert("Please enter a valid number for "+(el.name||el.id));
      }
    });
  }
});
