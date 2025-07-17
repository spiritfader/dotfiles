#!/bin/bash

mts2mp4() {
	ffmpeg -i "$1" -c:v copy -c:a aac -strict experimental -b:a 128k "$1.mp4"
}

mp4tomp3(){
	ffmpeg -i "$1" -b:a 192K -vn "$2"
}

video_all_x264() {
	for i in $1; do ffmpeg -i "$i" -c:a aac -b:a 128k -c:v libx264 -crf 20 "${i%.}_x264.mp4"; done
}

video_all_x265() {
	for i in $1; do ffmpeg -i "$i" -map_metadata -1 -vsync 0 -c:v libx265 -crf 20 -b:v 15M -vtag hvc1 -movflags +faststart -c:a aac -b:a 192k -pix_fmt yuv420p "${i%.}_x265.mp4"; done
}

video_all_hevc() {
	for i in $1; do ffmpeg -i "$i" -map_metadata -1 -c:a aac_at -c:v libx265 -crf 20 -pix_fmt yuv420p -vf "scale=trun c(iw/2)*2:trunc(ih/2)*2" -strict experimental "${i%.}_hevc.mp4"; done
}

videoto_x265() {
	ffmpeg -i "$1" -map_metadata -1 -vsync 0 -c:v libx265 -crf 20 -b:v 15M -vtag hvc1 -movflags +faststart -c:a aac -b:a 192k -metadata title="$2" -pix_fmt yuv420p "$2.x265.mp4"
}

videoto_av1() {
	# mapping between H.264 -> AV1
	# 19 -> 27
	# 23 -> 33
	# 27 -> 39
	# 31 -> 45
	# 35 -> 51
	# 39 -> 57
	
	ffmpeg -i "$1" -map_metadata -1 -c:a libopus -c:v libaom-av1 -crf 30 -b:v 0 -pix_fmt yuv420p -vf 'scale=trunc(iw/2)*2:trunc(ih/2)*2' -strict experimental "$2.av1.mp4"
}

videoto_hevc() {
	ffmpeg -i "$1" -map_metadata -1 -c:a aac_at -c:v libx265 -crf 20 -pix_fmt yuv420p -vf 'scale=trun    c(iw/2)*2:trunc(ih/2)*2' -strict experimental "$2.hevc.mp4"
}

videoto_h264() {
	ffmpeg -i "$1" -map_metadata -1 -c:a aac_at -c:v libx264 -crf 18 -profile:v main -pix_fmt yuv420p -vf 'scale=trunc(iw/2)*2:trunc(ih/2)*2' "$2.h264.mp4"
}

allmtsto_x265() {
	IFS=$(echo -en '\n\b'); for i in *.MTS; do ffmpeg -i "$i" -vsync 0 -c:v libx265 -crf 18 -b:v 15M -vtag hvc1 -c:a aac_at -b:a 192k -pix_fmt yuv420p "$i.mp4"; done;
}

allmtsto_h264() {
	IFS=$(echo -en '\n\b'); for i in *.MTS; do ffmpeg -i "$i" -vsync 0 -c:v h264_videotoolbox -crf 20 -c:a aac_at -b:a 192k -pix_fmt yuv420p "$i.mp4"; done;
}


videoto_x264() {
	ffmpeg -i "$1" -vsync 0 -c:v h264_videotoolbox -b:v 20M -allow_sw 1 -map_metadata -1 -vsync 0 -c:a aac_at -b:a 192k -profile:v main -pix_fmt yuv420p -vf 'scale=trunc(iw/2)*2:trunc(ih/2)*2' "$2.x264.mp4"
}

videoto_xhevc() {
	ffmpeg -i "$1" -vsync 0 -c:v hevc_videotoolbox -crf 30 -allow_sw 1 -map_metadata -1 -vsync 0 -c:a aac_at -b:a 192k -profile:v main -pix_fmt yuv420p -vf 'scale=trunc(iw/2)*2:trunc(ih/2)*2' "$2.xhevc.mp4"
}


video_cut() {
  # example: video_cut <input_video.mp4> <time_in_seconds> <output_file_without_extension>
  ffmpeg -i "$1" -c:v libx264 -segment_time "$2" -g 9 -sc_threshold 0 -force_key_frames "expr:gte(t,n_forced*9)" -f segment -reset_timestamps 1 "$3_%03d.mp4"
}

youtube_mp3() {
	yt-dlp -x 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --audio-format mp3 "$1"
}

youtube_mp4() {
	yt-dlp -F "$1"
	yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --buffer-size 5M "$1"
}

youtube_info() {
	yt-dlp -F "$1"
}

webptojpg() {
	dwebp "$1" -o "$1".jpg
}

towebp() {
	cwebp -q 80 "$1" -o "$1".webp
}