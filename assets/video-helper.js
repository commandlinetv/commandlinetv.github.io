var myPlayer;
videojs("video_1", {}, function(){
    // Player (this) is initialized and ready.
    console.log("READY");
    myPlayer = this;
    if(location.hash) {
        cueVideo(location.hash.slice(1));
    }
});

function cueVideo(timeCode) {
    var a = timeCode.split(":")
    var sec = a[0]*3600 + a[1]*60 + a[2]*1
    console.log(timeCode, sec);
    myPlayer.currentTime(sec);
    myPlayer.play();
    window.scrollTo(0,100);
}
