---
date:  2010-05-04
title: Encoding iPad Video from Linux
---
## Preamble

I hesitate to publish these instructions because [h.264 is patent-encumbered and dangerous](http://www.osnews.com/story/23236/Why_Our_Civilization_s_Video_Art_and_Culture_is_Threatened_by_the_MPEG-LA), and I don't want to contribute to its proliferation. But the steps here are general enough to be useful in many other situations, and interesting enough to merit discussion.

## The Goal

I was given an iPad. We own several DVDs that my son Ezra loves to watch, and I would like to let him watch them on the iPad. I selected *WALL&bull;E* and tried to use `dvd::rip` (via Ubuntu's vanilla `dvdrip` package), but it failed miserably. It 'read' 100 titles, each of which really turned out to be the movie with its chapters in the wrong order.

## World Domination in Four Easy Steps

Because the point-and-click method had failed, I turned to the command line. I never should have left, really. Here's the solution I found after much digging and trial-and-error.

 * Extract the VOBs
 * Concatenate the VOBs
 * Build a better ffmpeg
 * Encode!

### Extract the VOBs
 
The first step is to figure out exactly what we want to extract, and then to grab it. I used `dvdbackup` for this.

    # Show info about this disk
    brendan@ishmael:~/Videos$ dvdbackup -I | less
    # Output indicated that the main Title Set is 3
    brendan@ishmael:~/Videos$ dvdbackup -T 3
    brendan@ishmael:~/Videos$ tree -s WALL_E/
    WALL_E/
    `-- [       4096]  VIDEO_TS
        |-- [     163840]  VTS_03_0.BUP
        |-- [     163840]  VTS_03_0.IFO
        |-- [  170770432]  VTS_03_0.VOB
        |-- [ 1073739776]  VTS_03_1.VOB
        |-- [ 1073739776]  VTS_03_2.VOB
        |-- [ 1073739776]  VTS_03_3.VOB
        |-- [ 1073739776]  VTS_03_4.VOB
        |-- [ 1073739776]  VTS_03_5.VOB
        `-- [  111591424]  VTS_03_6.VOB

### Concatenate the VOBs

These files are pretty boring, but they can be concatenated since they're basically just MPEG streams. My initial approach was to cat them together and pipe the result to ffmpeg, which took up no additional disk space and had the virtue of lazily deferring IO while the encoder churned.

    cat *.VOB | ffmpeg -y -i - [...]
    
As nice as this plan was, I couldn't get it to work. My audio stream would disappear, and I couldn't figure out how to tell ffmpeg that it existed. The end result was beautiful video with no sound.

Instead, I piped them to one big file and operated on that. I also omitted the 0 file, since it turned out to be the DVD menu animations.

    rm VTS_03_0.VOB
    for x in *.VOB; do cat $x >> walle.vob; done

### Build a better ffmpeg

Because my goal was to use this on my iPad, I had rather nonstandard requirements: h.264 video and AAC audio with an MPEG-4 container. As I mentioned before, these formats are far from ideal &ndash; use OGG/Theora when you can. Presumably because they are non-free, the default Ubuntu ffmpeg package doesn't include these encoders. You'll need to replace it.

Follow this [helpful tutorial to build ffmpeg](http://ubuntuforums.org/showpost.php?p=8345112&postcount=636) and various encoders from source. I enabled all of the options.

### Encode!

The [iPad specifications](http://www.apple.com/ipad/specs/) indicate that it can do h.264 video up to 720p at 30fps with AAC sound at 160Kbps, 48kHz. To achieve this, I did a 2-pass encoding based on an [encoding guide](http://rob.opendot.cl/index.php/useful-stuff/ffmpeg-x264-encoding-guide/) and a list of [ffmpeg cheats](http://rodrigopolo.com/ffmpeg/cheats.html). I also did a lot of trial and error encoding, and my most pertinent piece of advice is this: test on a small VOB first. Fail quickly.

<code class='codeBlock'>
  ffmpeg -y -i walle.vob -r 30000/1001 -b 2M -bt 4M -pass 1 -vcodec libx264 -vpre fastfirstpass -threads 0 -an -f mp4 /dev/null
  <br/><br/>
  ffmpeg -y -i walle.vob -r 30000/1001 -b 2M -bt 4M -pass 2 -vcodec libx264 -vpre hq -threads 0 -map 0.0 -map 0.2 -async 1 -acodec libfaac -ac 2 -ab 160k -ar 48000 walle.mp4
</code>

Outside of the typical ffmpeg files/encoders/rates, there are a few interesting settings:

 * **-r 30000/1001**: set the frame rate to ~30fps
 * **-pass &lt;N&gt;**: indicate which pass we're doing
 * **-vpre &lt;value&gt;**: indicate which libx264 preset file to apply
 * **-threads 0**: let the encoder choose how many threads to use based on your hardware. Set this to utilize multicore/proc.
 * **-an**: disable audio, since the first pass only looks at video
 * **-f mp4 /dev/null**: set type to mp4 and output to /dev/null, since the first pass stores its statistics in secondary files and the actual video output should be thrown away.
 * **-map 0.0 -map 0.2**: switch to the English audio stream, which was located in the 0.2 stream instead of the normal 0.1. To figure out which was which, I did variations of `ffmpeg -y -i walle.vob -vn -acodec libfaac -ac 2 -ab 160k -ar 48000 -map 0.2:0.1 walle.aac` (extracting just audio) until I found the right stream.
 * **-async 1**: make the audio and video streams line up. Not necessary for all rips, but was in this case.

This produces a fairly high quality DVD rip that should be iPad compatible. Unfortunately, you'll need to leave the wonderful world of Linux to actually put the file on your iPad. Don't you just feel dirty doing this? I know I do. In lieu of that, you could host it on a local webserver. I can stream this bitrate over WiFi via nginx perfectly well.

## Closing Thoughts

The file I produced is currently not iPhone compatible. From what I can tell, the iPhone can only handle [640x480 video at 1.5mbps](http://www.ilounge.com/index.php/articles/comments/the-complete-guide-to-ipod-video-formats-and-display-resolutions/). You could do one of three things: tune the ffmpeg parameters to produce a video that'll work on both, produce one separate file for each device, or do what I did and eschew the the low resolution option.

I'd like to figure out how to do this encoding on the fly. `hdparm` says my DVD transfer speeds clock in around 2-3MB/sec, which should stay ahead of the CPU during encoding. It would be wonderful if the only additional disk space taken up by this process were for intermediate first-pass statistics and the final encoded video. As things happened, I copied the files once from CD and again to concatenate them. That's less than ideal.

I'd also like to showcase an open codec like OGG/Theora, since I strongly believe in that cause. Doing that now can be an exercise for the reader, and it shouldn't be too hard; it's just a matter of finding the correct ffmpeg parameters.

**Updated**: I changed some audio-specific parameters because the sound wasn't lining up with the video.

