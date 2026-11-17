# MASTER IMPLEMENTATION PROMPT — PRODUCTION FASTLANE CI/CD PIPELINE SETUP (FLUTTER / ANDROID)

> **How to use this template:** Copy and paste the prompt below into any Flutter/Android application project. Replace the placeholders (`<YOUR_PACKAGE_NAME>`, etc.) or let the AI automatically inspect your `pubspec.yaml` and Android package name.

---

```markdown
# TASK: Production Fastlane CI/CD Setup for Flutter & Google Play Store

Act as a Senior Mobile DevOps Engineer, Build Release Architect, and Android Specialist. 

Your task is to set up a complete, professional, battle-tested Fastlane automation pipeline for this Flutter Android project. 

The pipeline must automate version bumping, appbundle builds, Google Play uploads (Internal, Closed Testing / Alpha, Beta, Production), ProGuard/R8 deobfuscation mapping uploads, automated changelog generation, and Git release commits/tags/pushes.

Inspect the repository first (read `pubspec.yaml`, `android/app/build.gradle`, package name, etc.) and implement the entire setup directly.

---

## 1. Core Requirements & Architecture

### A. Directory Structure
Ensure the following structure is established in `android/`:
```
android/
├── Gemfile
├── .gitignore (must ignore api-key.json and build artifacts)
└── fastlane/
    ├── Appfile
    ├── Fastfile
    ├── api-key.json (placeholder / documentation)
    └── metadata/
        └── android/
            └── en-US/
                └── changelogs/
                    └── <build_number>.txt
```

### B. Bundler & Gemfile Configuration
Create `android/Gemfile`:
```ruby
source "https://rubygems.org"

gem "fastlane"
```
*Note: Do not pin conflicting legacy google-api-client gems. Fastlane manages its dependencies cleanly.*

### C. Fastlane Appfile Configuration
Create `android/fastlane/Appfile`:
- Dynamically read the package name from `android/app/build.gradle` (or `applicationId`).
- Point `json_key_file` to `fastlane/api-key.json` (or read from environment variable `PLAY_STORE_JSON_KEY`).

### D. Automated Version & Build Number Management
In `android/fastlane/Fastfile`, implement a robust Ruby helper method `get_target_build_number(options)`:
1. Parse `pubspec.yaml` using regex matching `version: ([^\s+]+)\+(\d+)`.
2. Determine `next_build = current_build + 1`.
3. If `options[:build_number]` or `options[:version_code]` is passed via CLI, use that explicit number.
4. If running in an interactive terminal, prompt the user with default `[ENTER = next_build]`.
5. If running in CI/non-interactive mode, use `next_build` automatically.
6. Automatically update `pubspec.yaml` in-place to `version: <version_name>+<target_build>`.

### E. Flutter Release AppBundle Build
Implement `build_flutter_aab(build_num)` in `Fastfile`:
1. Navigate to project root.
2. Execute `flutter build appbundle --release --build-number=#{build_num}`.
3. Validate that `build/app/outputs/bundle/release/app-release.aab` exists; fail with a descriptive error if missing.

### F. Automated Changelogs & ProGuard / R8 Mapping Upload
1. Automatically write release notes to `android/fastlane/metadata/android/en-US/changelogs/<build_number>.txt`.
2. Accept custom release notes via CLI option `release_notes:"..."` or `changelog:"..."`; provide professional fallback bullet points if omitted.
3. Check for ProGuard mapping at `build/app/outputs/mapping/release/mapping.txt` and attach it to the Play Store upload so stack traces are automatically deobfuscated in Google Play Console.

### G. Complete Lane Definitions
Implement the following lanes in `Fastfile` under `platform :android`:

1. `lane :build` — Bumps version in `pubspec.yaml` and compiles the release AAB locally without uploading.
2. `lane :internal` — Builds and uploads release AAB + mapping to the **Google Play Internal Testing track**.
3. `lane :closed` — Builds and uploads release AAB + changelog + mapping to the **Google Play Closed Testing track (`alpha`)**.
4. `lane :beta` — Builds and uploads release AAB + changelog + mapping to the **Google Play Open Testing track (`beta`)**.
5. `lane :production` — Builds and uploads release AAB + changelog + mapping to the **Google Play Production track**.
6. `lane :git_release` — Automatically commits the bumped `pubspec.yaml` and new changelog file with message:
   `chore(release): bump version to <version>+<build> and deploy to <track>`
   Creates a Git tag `v<version>+<build>` and pushes to current Git remote/branch.

### H. Google Play Console API Conflict Resilience
In `upload_to_play_store`, ensure the following options are set:
```ruby
upload_to_play_store(
  track: track_name,
  aab: aab_path,
  json_key: File.expand_path("api-key.json", __dir__),
  skip_upload_apk: true,
  skip_upload_metadata: false,
  skip_upload_changelogs: false,
  skip_upload_images: true,
  skip_upload_screenshots: true,
  timeout: 600,
  mapping: mapping_path_if_exists,
  changes_not_sent_for_review: false,
  rescue_changes_not_sent_for_review: true
)
```

### I. Security & Git Hygiene
1. Update `android/.gitignore` and root `.gitignore`:
   - Ignore `android/fastlane/api-key.json`
   - Ignore `android/fastlane/report.xml`
   - Ignore `*.keystore`, `*.jks`, `key.properties`
2. Never commit raw Google Play Service Account JSON keys to Git.

---

## 2. Fastfile Production Implementation Template

Implement `android/fastlane/Fastfile` exactly as follows:

```ruby
ENV["FASTLANE_SKIP_UPDATE_CHECK"] = "1"
ENV["FASTLANE_HIDE_CHANGELOG"] = "1"
ENV["FASTLANE_OPT_OUT_USAGE"] = "1"

default_platform(:android)

def get_target_build_number(options = {})
  pubspec_path = File.expand_path("../../pubspec.yaml", __dir__)
  current_version = "1.0.0"
  current_build = 1

  if File.exist?(pubspec_path)
    content = File.read(pubspec_path)
    if (match = content.match(/^version:\s*([^\s+]+)\+(\d+)/))
      current_version = match[1]
      current_build = match[2].to_i
    end
  end

  default_next = current_build + 1

  if options[:build_number] || options[:version_code]
    target_build = (options[:build_number] || options[:version_code]).to_i
  elsif UI.interactive?
    UI.important("--------------------------------------------------")
    UI.important("📦 Current pubspec.yaml version : #{current_version}+#{current_build}")
    UI.important("🔢 Next default Build Number   : #{default_next}")
    UI.important("--------------------------------------------------")

    user_input = UI.input("Enter build number (Press ENTER to use default #{default_next}): ")
    target_build = user_input.strip.empty? ? default_next : user_input.strip.to_i
  else
    target_build = default_next
  end

  # Update pubspec.yaml in-place
  if File.exist?(pubspec_path)
    new_content = File.read(pubspec_path).sub(/^version:\s*.+$/, "version: #{current_version}+#{target_build}")
    File.write(pubspec_path, new_content)
    UI.success("Updated pubspec.yaml to version: #{current_version}+#{target_build}")
  end

  UI.success("=> Using Build Number: #{target_build}")
  target_build
end

def get_full_version_string
  pubspec_path = File.expand_path("../../pubspec.yaml", __dir__)
  if File.exist?(pubspec_path)
    content = File.read(pubspec_path)
    if (match = content.match(/^version:\s*([^\s]+)/))
      return match[1]
    end
  end
  "1.0.0+1"
end

def build_flutter_aab(build_num)
  root_dir = File.expand_path("../..", __dir__)
  UI.message("Building Flutter release appbundle from: #{root_dir}")
  
  Dir.chdir(root_dir) do
    sh("flutter build appbundle --release --build-number=#{build_num}")
  end

  aab_path = File.expand_path("../../build/app/outputs/bundle/release/app-release.aab", __dir__)
  unless File.exist?(aab_path)
    UI.user_error!("Could not find built appbundle at: #{aab_path}")
  end
  
  aab_path
end

def commit_and_tag_release(track_name, build_num)
  root_dir = File.expand_path("../..", __dir__)
  version_str = get_full_version_string
  tag_name = "v#{version_str}"

  UI.message("Creating Git release commit and tag: #{tag_name}")
  Dir.chdir(root_dir) do
    sh("git add pubspec.yaml android/fastlane/metadata/android/en-US/changelogs/#{build_num}.txt")
    sh("git commit -m \"chore(release): bump version to #{version_str} and deploy to #{track_name}\"")
    sh("git tag -a \"#{tag_name}\" -m \"Release #{version_str} (#{track_name})\"")
    sh("git push origin --follow-tags")
  end
  UI.success("Successfully pushed release commit and tag to remote!")
rescue => e
  UI.important("Git commit/tagging skipped or encountered an error: #{e.message}")
end

platform :android do
  lane :build do |options|
    build_num = get_target_build_number(options)
    build_flutter_aab(build_num)
  end

  lane :internal do |options|
    deploy_to_track('internal', options)
  end

  lane :closed do |options|
    track_name = options[:track] || 'alpha'
    deploy_to_track(track_name, options)
  end

  lane :beta do |options|
    deploy_to_track('beta', options)
  end

  lane :production do |options|
    deploy_to_track('production', options)
  end

  def deploy_to_track(track_name, options)
    build_num = get_target_build_number(options)
    aab_path = build_flutter_aab(build_num)
    mapping_path = File.expand_path("../../build/app/outputs/mapping/release/mapping.txt", __dir__)

    # Write changelog
    changelogs_dir = File.expand_path("metadata/android/en-US/changelogs", __dir__)
    FileUtils.mkdir_p(changelogs_dir)
    changelog_content = options[:release_notes] || options[:changelog] || [
      "• Performance enhancements and bug fixes.",
      "• UI/UX optimizations and stability improvements."
    ].join("\n")
    File.write(File.join(changelogs_dir, "#{build_num}.txt"), changelog_content)
    UI.success("Generated changelog for build #{build_num}")

    upload_params = {
      track: track_name,
      aab: aab_path,
      json_key: File.expand_path("api-key.json", __dir__),
      skip_upload_apk: true,
      skip_upload_metadata: false,
      skip_upload_changelogs: false,
      skip_upload_images: true,
      skip_upload_screenshots: true,
      timeout: 600,
      changes_not_sent_for_review: false,
      rescue_changes_not_sent_for_review: true
    }
    upload_params[:mapping] = mapping_path if File.exist?(mapping_path)

    upload_to_play_store(upload_params)
    UI.success("Successfully uploaded Build #{build_num} to Google Play track [#{track_name}]! 🎉")

    if options[:git] == true || options[:git_tag] == true
      commit_and_tag_release(track_name, build_num)
    end
  end
end
```

---

## 3. Verification & Execution Instructions

After creating the files:
1. Verify `bundle install` executes without gem conflicts.
2. Verify running `bundle exec fastlane closed --dry-run` or inspecting the Fastfile syntax.
3. Provide instructions on how to run deployments:
   - `cd android`
   - `bundle exec fastlane closed` (or `bundle exec fastlane closed build_number:15 release_notes:"• New feature\n• Bug fixes" git:true`)
```
