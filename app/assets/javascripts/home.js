var items, length, deg, z, move = 0 ;

  function rotate(direction){
    move += direction;

    for(var i = 0; i < length ; i++){
      items[i].style.transform = "rotateY("+(deg*(i+move))+"deg) translateZ("+z+"px)";
    }
  }
function load(){
  items = document.getElementsByClassName('item');
  length = items.length;

  deg = 360 / length;
  z = (items[0].offsetWidth / 2) / Math.tan((deg / 2) * (Math.PI / 180));

  for(var i = 0; i < length; i++){
    items[i].style.transform = "rotateY("+(deg*i)+"deg) translateZ("+z+"px)";
      rand1 = Math.round(Math.random()*255);
      rand2 = Math.round(Math.random()*255);
      rand3 = Math.round(Math.random()*255);
      rand4 = Math.round(Math.random()*255);
      rand5 = Math.round(Math.random()*255);
      rand6 = Math.round(Math.random()*255);
      items[i].style.backgroundColor = "rgba("+rand1+", "+rand2+", "+rand3+", "+rand4+", "+rand5+", "+rand6+", 0.6)";
  }
}
window.addEventListener('load', load);


