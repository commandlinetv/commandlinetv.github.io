# Command Line TV

These are the Jekyll sources for the [commandline.tv](http://commandline.tv/)
web site. The primary way that you can help us maintain the site is to provide
or fix our episode transcripts, which are kept in the `_data` directory.

The format for each item is:

``` .yaml
- time: "00:00:25"
  speaker: League
  index: "`*` wildcard"
  cmd: |
    echo "This is a sample command."
  caption: |
    Today we're going to talk about wildcards
    and text processing using pipelines.
```

where all but the `time` and `caption` entries are optional.

The time format must be "HH:MM:SS", and cannot contain sub-second resolution.
The caption lines should have a newline in a sensible place, but a maximum of
two lines, with up to about 45-50 characters per line.

The `index` key, if present, will add an entry to the site index. Use
back-ticks to enclose literal commands and options. We try not to use the same
index term multiple times in one episode, so tag the point where we *begin*
talking about that thing. Currently we support only one index term per
time-code.

The `cmd` key is meant to provide a complete command line that can be
copy-pasted, and corresponds to what is being typed on-screen at that moment.

After making changes to a transcript, we run

```
rake reindex
```

and commit also the changes to `_data/topics.yaml`

## Our check-list for releasing a new episode

Once we have a final cut exported to an MP4 file, here are the steps to publish
it as a new episode. Replace `N` with the episode number.

 1. Capture a video snapshot for the poster, using VLC » Video » Take snapshot,
    then rename it:

    ```
    mv ~/vlcsnap* snapNNN.png
    ```

 2. Run the scripts in Makefile, to transcode and upload:

    ```
    make -j NUM=N FILE=~/tmp/Ep-NN.mp4
    ```

 3. Write episode transcript in paragraph form, in `_data/episodeNNN.a.txt`. I
    recommend using playback speed 0.5x. You can include speaker annotation as
    its own paragraph, prefixed with a colon. Then run

    ```
    _scripts/captionbreak _data/episodeNNN.a.txt > _data/episodeNNN.b.txt
    ```

    See the comment in `_scripts/captionbreak` for more details.

 4. Fill out the description, `tagline`, and `size` in `_drafts/episodeNNN.md`.
    The `size` should be the exact size, in bytes, of `episodeNNN.mp4`.

 5. Add timings to `_data/episodeNNN.b.txt` by prefixing each caption couplet
    with `M:SS` on a line by itself. I can usually do this at 1.0x and just
    look at the timer in VLC. Then run

    ```
    _scripts/yamlify _data/episodeNNN.b.txt > _data/episodeNNN.yaml
    ```

 6. Add `index` terms and `cmd` lines to `_data/episodeNNN.yaml`. Test them
    using:

    ```
    rake reindex drafts=1
    jekyll serve -D
    ```

 7. Spot-check the captions file `_site/episodeNNN/episodeNNN.srt` by loading
    it in VLC.

 8. Run `rake reindex` to exclude drafts, and commit changes.

 9. Once the release date arrives, use `git mv` to move the
    `_drafts/episodeNNN.md` to `_posts`, and timestamp it. Test it again, using

    ```
    rake reindex
    jekyll serve
    ```

    then commit changes and push.

 10. [Ping feedburner](http://www.feedburner.com/fb/a/pingSubmit?bloglink=http%3A%2F%2Ffeeds.feedburner.com%2Fcommandlinetv),
    and it will tweet about the new episode.

 11. Upload the *original* MP4 file to YouTube. Copy the description from the
    web site, and use these tags: Command-line interface, Unix (Operating
    System), Unix-like, Unix Shell, Operating System, Programming Language,
    Technology, GNU/Linux Operating System.

 12. Once the YouTube video is ready, upload the captions file.
