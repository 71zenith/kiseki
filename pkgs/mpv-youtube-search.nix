{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  buildLua,
}:
buildLua (finalAttrs: {
  pname = "mpv-youtube-search";

  version = "v1.0.0";
  src = fetchFromGitHub {
    owner = "willswats";
    repo = finalAttrs.pname;
    rev = "51dc4e5ef1f2b6953755427122cf4706b8f98a80";
    hash = "sha256-LD3uhE0uELlOZlSbWe2+sqozqOmfRY4m75Cxu3LgUaw=";
  };
  passthru.updateScript = unstableGitUpdater {};
  meta = {
    description = "Search youtube from MPV";
    homepage = "https://github.com/willswats/mpv-youtube-search";
    license = lib.licenses.mit;
    maintainers = [lib.maintainers._71zenith];
  };
})
