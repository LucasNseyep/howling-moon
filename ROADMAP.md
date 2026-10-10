# Howling Moon roadmap

Written 2026-10-10, after a full review of the codebase at commit `ffc709d` (last commit 2023-04-10).

This document records what state the app is in, what is broken, and the work needed to make it shippable again. The work is grouped into eight projects. Each project says why it matters and lists the pull requests that make it up, with the reason for each one.

## Contents

1. [Where the app stands](#where-the-app-stands)
2. [What is broken](#what-is-broken)
3. [How the roadmap is ordered](#how-the-roadmap-is-ordered)
4. [Open decisions](#open-decisions)
5. [The projects](#the-projects)

## Where the app stands

| Area | State |
| --- | --- |
| Size | Three controllers, four models, a D3 tree view, Devise auth |
| Stack | Ruby 3.1.2 and Rails 7.0.4.2, both past end of security support |
| Tests | 5 runs, 2 failures, 1 error. No fixtures, no controller or system tests |
| CI | None |
| Deployment | `www.howlingmoon.xyz` no longer resolves. No Procfile or Dockerfile in the repo |
| Local setup | Boots, and the test suite runs, on Ruby 3.1.2 with a local Postgres |

## What is broken

The first three items under "Core flows" and the cycle and orphan items under "Data integrity" were confirmed by running the model code against the test database. The rest come from reading the code.

### Core flows

- **Connecting two unlinked thoughts never creates a collection.** `add_collection` calls `Collection.create` with no title (`app/controllers/thoughts_controller.rb:104`). The title validation, added later, rejects it. The thoughts end up connected but with no collection, so they never appear in one.
- **Thought validation is inverted** (`app/models/thought.rb:14`). A completely empty thought is valid. A content-only thought submitted from the form, where the title arrives as an empty string, is rejected.
- **Failed saves have no error path.** `create` and `update` in `ThoughtsController` neither render nor redirect when the save fails, so the form silently does nothing.
- **Collection titles are unique across all users** (`app/models/collection.rb:8`). One user's "Ideas" blocks everyone else from using that title.

### Security

- **No authorization on thoughts.** `set_thought` loads any thought, and its ownership check does nothing (`thoughts_controller.rb:113-116`). `edit`, `update`, `destroy`, `connect` and `disconnect` all work on other users' thoughts.
- **No authorization on collections.** `edit`, `update` and `destroy` use `Collection.find` (`collections_controller.rb:43,66,73`).
- **Unescaped HTML in the tree.** Thought titles and content are injected with `.html()` (`tree_map_controller.js:85,453`).
- **Scripts loaded over plain HTTP.** D3 v3, jQuery 1.10 and Underscore come from `http://` URLs (`app/views/layouts/application.html.erb:12-15`). Browsers block these on an HTTPS site, so the graph would not render in production. Line 15 also references a `d3-context-menu.js` that does not exist.

### Data integrity

- **Cycles are allowed.** A can be B's parent while B is A's parent. `root` and `ancestors` (`thought.rb:49-66`) then loop forever and hang the request.
- **Deleting a thought leaves its connections behind.** There is no `dependent: :destroy` and no foreign keys on `connections`. The deleted thought's children become extra roots, and the tree only draws the first root (`tree_map_controller.js:32`), so they vanish from the graph.
- **Collections have no owner column.** Ownership is inferred through thoughts, so a collection with no thoughts is invisible to everyone.
- **The tree is keyed by title.** Two thoughts with the same title in one collection corrupt the graph (`collections_controller.rb:32`, `tree_map_controller.js:11`).
- **Disconnect and collection delete only half clean up.** Disconnecting clears the collection on one thought but not its descendants. Deleting a collection only removes the first thought's connections.

### Frontend and leftovers

- **Drag-and-drop in the tree cannot work.** It calls an undefined `initiateDrag`, assigns to undeclared variables, and persists nothing.
- **Dead code.** `tree_map_controller_og.js`, `review_controller.js` (fully commented out), `hello_controller.js`, `yarn-error.log`, and `console.log` calls in every Stimulus controller.
- **Three near-identical search controllers**, each concatenating the query into the URL without encoding it.
- **Markup problems.** Inline `<style>` blocks override Bootstrap's `.col-3` inside partials. There are unclosed tags in `thoughts/index.html.erb:19` and `_list-browse.html.erb`.
- **Placeholder content.** The navbar avatar is one hardcoded Slack-hosted photo for every user. The home page shows invented testimonials under real people's names.
- **Mail is unconfigured.** The production mailer host is `TODO_PUT_YOUR_DOMAIN_HERE` and there is no SMTP setup, so password reset cannot work.

## How the roadmap is ordered

Five rules decided the order of the projects.

1. **Build the safety net before changing anything.** The upgrade and the rewrites touch most of the app. Without tests and CI, there is no way to know whether they broke something.
2. **Fix by severity: security, then correctness, then maintainability, then features.** A leak of another user's notes is worse than a broken button, which is worse than ugly code.
3. **Respect dependencies.** Scoping queries to the current user (project 2) is simpler once collections have an owner. Fixing connect (project 3) depends on the connection rules from project 2. The graph rewrite (project 5) is easier on a modern build (project 4).
4. **Fix behaviour on the old stack, then upgrade.** Changing behaviour and framework versions in the same step makes it impossible to tell which one caused a regression.
5. **Do not deploy until the first four projects are done.** Putting the current code on the public internet would expose the authorization holes.

Project 8 is the only one that adds features. Everything before it restores what the app already claims to do.

## Open decisions

These are yours to make, and they change the plan.

| Decision | Why it matters | Assumed here |
| --- | --- | --- |
| What is the app for now: portfolio piece, personal tool, or public product? | Sets where to stop. A portfolio piece needs projects 1 to 3 and a deploy. A public product needs all eight | Public product |
| Does a thought keep exactly one parent (a tree) or link to many (a graph)? | Changes PRs 6, 8, 14 and 15. Hard to reverse once users have data | Tree, as today |
| Should auto-created collections get a default name or prompt for one? | Shapes PR 8 | Default name, renamed later |
| Keep drag-to-reparent in the tree? | Decides PR 16 | Decide after the rewrite |
| Where to host? | Decides PR 21 | Undecided |

## The projects

### 1. Baseline and safety net

**Why.** The repo has no working tests and no CI. Every later project changes code that nothing currently checks. This project is cheap and makes the rest safe.

| PR | What | Why |
| --- | --- | --- |
| 1. Repo hygiene | Commit the `Gemfile.lock` platform line. Delete `yarn-error.log` and the dead JS controllers. Remove `console.log` calls. Refresh the README setup section | Dead files hide what the app really does and add noise to every later diff |
| 2. Fixtures and model tests | Add fixtures for users, thoughts, collections and connections. Fix the three failing tests. Add tests for `connect`, `disconnect`, `root` and `ancestors` | The current tests fail because `User.first` is nil. One of them passes for the wrong reason, which hid the inverted validation |
| 3. CI | A GitHub Actions workflow that runs the tests, RuboCop, `bundler-audit` and Brakeman | Tests that are not run automatically stop being run. The two scanners will also list the known vulnerabilities in the locked gems |

### 2. Security and ownership

**Why.** Any signed-in user can read, edit, delete and re-link any other user's notes by changing an id in the URL. A notes app holds private writing, so this must be fixed before the app is public again.

| PR | What | Why |
| --- | --- | --- |
| 4. Scope every lookup to the current user | Replace `Thought.find` and `Collection.find` with lookups through `current_user`, including the `selected_id` parameter. Add request tests that prove cross-user access returns 404 | Closes the authorization holes. The tests stop them coming back |
| 5. Give collections an owner | Add `collections.user_id` and backfill it from each collection's thoughts. Scope title uniqueness to the user. Remove the invalid `has_one :user, through: :thought` | Ownership inferred through thoughts breaks when a collection is empty, and global title uniqueness lets users block each other |
| 6. Harden the connection graph | Add foreign keys and bigint columns on `connections`. Add `dependent: :destroy`. Add a validation that rejects self-links and cycles | A cycle hangs the server in an infinite loop. Orphaned connections make thoughts disappear from the graph |

### 3. Core flow fixes

**Why.** The product's central promise is linking thoughts into collections, and that flow does not work. Creating a note with only content fails silently. These are the bugs a first-time user hits in the first five minutes.

| PR | What | Why |
| --- | --- | --- |
| 7. Thought validation and error handling | Require a title or content. Re-render the form with errors when `create` or `update` fails | Today an empty thought saves and a content-only thought does not, with no message either way |
| 8. Connect and disconnect | Create a titled collection on first connect. Move the whole subtree on disconnect. Handle "already has a parent" with a message instead of a 500 | Connecting two unlinked thoughts leaves them outside any collection, so the main feature produces nothing visible |
| 9. Collection create and delete | Wrap create in a transaction and render errors. Remove all connections when a collection is deleted | Create can raise half way through. Delete leaves stale links between thoughts that no longer share a collection |
| 10. One nil-safe card partial | Extract a shared thought-card partial that uses `truncate`, replacing the six copies that call `.length` on fields that can be nil | A thought with no title or no content crashes every list it appears in. Six copies means six places to fix each bug |

### 4. Platform upgrade

**Why.** Ruby 3.1 and Rails 7.0 no longer receive security fixes, and the locked gems are from early 2023. The cost of upgrading grows with every release skipped, and hosting platforms drop old runtimes.

| PR | What | Why |
| --- | --- | --- |
| 11. Ruby upgrade | Move from Ruby 3.1 to a current release. Bump Puma, pg, Nokogiri and Devise | Needed before Rails can move, and it clears most of the known gem vulnerabilities |
| 12. Rails upgrade | Go 7.0 to 7.1 to 7.2 to 8.x, one PR per step, updating `load_defaults` each time | One version at a time keeps deprecation warnings readable and regressions easy to trace |
| 13. Asset build | Replace `sassc-rails` and webpack with `dartsass-rails` plus esbuild or importmap. Drop the `webdrivers` gem. Pin `simple_form` to a released version | `sassc-rails` and `webdrivers` are deprecated. A dependency tracked from a git branch can change under you |

### 5. Graph view rewrite

**Why.** The tree is the feature that sets the app apart, and it is the weakest code in the repo: 554 lines adapted from a D3 v3 example, depending on three scripts the browser will block over HTTPS. D3 v3's API was removed in v4, so this is a rewrite, not an upgrade.

| PR | What | Why |
| --- | --- | --- |
| 14. Serve tree data by id | A JSON endpoint that returns nodes with `id` and `parent_id`, and supports more than one root | Keying nodes by title breaks on duplicate titles. Showing only the first root hides thoughts |
| 15. Rewrite the tree controller on D3 v7 | Bundle D3 from npm. Remove jQuery and Underscore. Escape text. Size the graph from its container | Removes the blocked HTTP scripts and the HTML injection, and makes the graph work in production at all |
| 16. Decide on drag-to-reparent | Remove it, or make it real by saving the new parent through the connect endpoint | The current drag code throws errors and saves nothing. A control that looks like it works and does not is worse than no control |

### 6. Frontend cleanup

**Why.** None of this is urgent, but it is what makes the app slow to change and what a visitor or reviewer sees first.

| PR | What | Why |
| --- | --- | --- |
| 17. One search controller | Merge the three controllers into one with debounce and URL encoding, or replace them with Turbo Frames | Three copies drift apart. Unencoded queries break on `&` and `#`. A request per keystroke is wasteful |
| 18. Layout and styles | Remove inline styles and the Bootstrap overrides. Fix unclosed tags. Use the footer partial everywhere. Split the 829-line `_homepage.scss` | Overriding `.col-3` globally from inside a partial affects every page that renders it. Invalid markup renders differently across browsers |
| 19. Home page and navbar content | Remove the invented testimonials and the hardcoded Slack avatars. Show initials or a Gravatar | Fake reviews under real names are a trust and consent problem on a public site. The images are hosted on someone else's Slack workspace and can vanish |

### 7. Redeploy

**Why.** The app is offline. It should come back only after projects 1 to 4, so that what goes live is secure, working and on a supported stack.

| PR | What | Why |
| --- | --- | --- |
| 20. Production config | Turn on `force_ssl`. Set a real mailer host and SMTP provider. Add a content security policy. Read `DATABASE_URL` | Password reset cannot send mail today. HTTPS and a CSP are the baseline for an app that takes logins |
| 21. Deployment target | Add a Dockerfile with Kamal, Fly or Render config, or a Heroku Procfile. Point a domain at it | The repo holds no record of how the app was deployed, so the deploy cannot be reproduced |

### 8. Product work

**Why.** Once the app does what it already promises, these are the gaps a real user would feel. Each one should be judged on its own. None blocks a relaunch.

| PR | What | Why |
| --- | --- | --- |
| 22. An "all thoughts" view with pagination | A page listing every thought, linked or not, in pages | The index shows only unlinked thoughts, so a linked thought can be reached only through its collection's graph |
| 23. Rename and reorganise | Rename auto-created collections. Move a thought to a new parent in one step | Today moving a thought means disconnecting it and connecting it again, and the UI says so in a footnote |
| 24. Richer notes | Markdown or Action Text for content. Export | Plain text limits what people will keep in the app. Export lowers the risk of committing to it |
| 25. Use or drop `pg_search_documents` | Build a global search across thoughts and collections, or remove the unused table | Unused schema is confusing. A single search box is the stated goal of "eliminating the time spent retrieving your thoughts" |
