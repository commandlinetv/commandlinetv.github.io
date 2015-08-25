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

 1. Upload `Ep-NN.mp4` to YouTube, so it can start converting. Use these tags:
    Command-line interface, Unix (Operating System), Unix-like, Unix Shell,
    Operating System, Programming Language, Technology, GNU/Linux Operating
    System.

 2. Capture a video snapshot for the poster, using VLC » Video » Take snapshot,
    then rename it:

    ```
    mv ~/vlcsnap* snapNNN.png
    ```

 3. Run the scripts in Makefile, to transcode and upload:

    ```
    make -j NUM=N FILE=~/tmp/Ep-NN.mp4
    ```

 4. Write episode transcript in `_data/episodeNNN.yaml`.

 5. Write episode description in `YYYY-MM-DD-episodeNNN.md`

 6. Fill in episode `tagline` (same file) and `size` of mp4 file, in bytes.

 7. After adding indices to transcript, reindex:

    ```
    rake reindex
    ```

 8. Test website locally using

    ```
    jekyll serve
    ```

 9. Spot-check episode entry in `_site/rss.xml`.

 10. Push new content to GitHub.

    ```
    git add _posts _data episodeNNN
    git commit -m "Episode N"
    git push
    ```

 11. Tweet about episode from CLTV account.

 12. Upload captions in `_site/episodeNNN/episodeNNN.srt` to YouTube.

