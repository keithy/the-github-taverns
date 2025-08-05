tech="${TECH:-}"; type="${ITEM_TYPE:-}"; pipeline="${PIPELINE:-}"
top="${pipeline%%/*}"
f="${0##*/}"
case "the-github-taverns/examples/hooks/40-pre-publish/--mise--30-build-package.sh" in
  "${tech}--"*) : ;;
  *"--${type}--"*) : ;;
  *"--"*) exit 0 ;;
  *) : ;;
esac
echo "mise only: 30-build-package"
