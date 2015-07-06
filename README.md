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

 1. Upload video to S3

    ```
    s3cmd put -P EpNN.mp4 s3://commandline.tv/media/episodeNNN.mp4
    ```

 2. Upload video to YouTube

 3. Capture a video snapshot using VLC » Video » Take snapshot.

 4. Overlay with text (TODO) and convert to JPG.

 5. Upload snapshot to S3 and YouTube

    ```
    s3cmd put -P episodeNNN.jpg s3://commandline.tv/media/
    ```

 6. Create skeletons for episode:

    ```
    rake episode num=N
    ```

 7. Write episode description in `YYYY-MM-DD-episodeNNN.md`

 8. Fill in episode tagline (same file)

 9. Write episode transcript in `_data/episodeNNN.yaml`.

     a. TODO: add recommendations for managing
     b. TODO: transcription details

 10. After adding indices to transcript, reindex:

    ```
    rake reindex
    ```

 11. Test website locally using

    ```
    jekyll serve
    ```

 12. Spot-check episode entry in `_site/rss.xml`.

 13. Push new content to GitHub.

    ```
    git add _posts _data episodeNNN
    git commit -m "Episode N"
    git push
    ```

 14. Tweet about episode from CLTV account.

 15. Upload captions in `_site/episodeNNN/episodeNNN.srt` to YouTube.

