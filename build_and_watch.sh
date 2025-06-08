#/bin/sh
nix build && sudo rm slides.pdf && sudo rm slides_no_pause.pdf && cp result/slides*.pdf .
while inotifywait -e close_write -e moved_to -e create -r .; do
  nix build && sudo rm slides.pdf && sudo rm slides_no_pause.pdf && cp result/slides*.pdf .
done
