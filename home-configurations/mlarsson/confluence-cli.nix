{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "confluence-cli";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "pchuri";
    repo = "confluence-cli";
    rev = "v${version}";
    hash = "sha256-CAKQewvgBODnxSoP5AmK4qwqggCzkEETUIfLwwZgf2U=";
  };

  npmDepsHash = "sha256-PWk5Szd6SF9Fo1Rx+ddzTECNqecTZtL9inXMILuWcD8=";

  # confluence-cli has no `build` script in package.json, so skip the
  # default `npm run build` step that buildNpmPackage would otherwise run.
  dontNpmBuild = true;

  meta = {
    description = "Command-line interface for Atlassian Confluence";
    homepage = "https://github.com/pchuri/confluence-cli";
    license = lib.licenses.mit;
    mainProgram = "confluence";
  };
}
