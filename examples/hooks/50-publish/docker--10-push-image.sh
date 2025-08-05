tech="${TECH:-}";  pipeline="${PIPELINE:-}"
top="${pipeline%%/*}"
f="${0##*/}"
case "the-github-taverns/examples/hooks/50-publish/docker--10-push-image.sh" in
  "${tech}--"*) : ;;
  *"--${top}--"*) : ;;
  *"--"*) exit 0 ;;
  *) : ;;
esac
echo "docker only: 10-push-image"
