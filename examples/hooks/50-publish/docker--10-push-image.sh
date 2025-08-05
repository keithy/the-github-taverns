tech="${TECH:-}"; type="${ITEM_TYPE:-}"; pipeline="${PIPELINE:-}"
top="${pipeline%%/*}"
f="${0##*/}"
case "the-github-taverns/examples/hooks/50-publish/docker--10-push-image.sh" in
  "${tech}--"*) : ;;
  *"--${type}--"*) : ;;
  *"--"*) exit 0 ;;
  *) : ;;
esac
echo "docker only: 10-push-image"
