# ══════════════════════════════════════════════════════════════════
# Shell Options & History
# ══════════════════════════════════════════════════════════════════
#
# Zsh has ~170 options that control shell behavior. These are the
# ones worth setting explicitly — everything else uses sane defaults.
#
# Options are grouped by purpose with comments explaining what each
# does and why it's enabled. If you're learning zsh, read through
# these — they're the foundation of how your shell behaves.
#
# Docs: https://zsh.sourceforge.io/Doc/Release/Options.html
# ══════════════════════════════════════════════════════════════════

# ── Directory navigation ─────────────────────────────────────────
# These options make navigating directories faster and more intuitive.
# Combined with the dir stack aliases (d, 1-9) in 08-aliases.zsh,
# they give you a powerful directory history system.
setopt auto_cd               # type a dir name to cd into it (no `cd` needed)
setopt auto_pushd            # every cd pushes onto the dir stack
setopt pushd_ignore_dups     # don't stack the same directory twice
setopt pushd_silent          # don't print the stack on every pushd/popd
setopt cdable_vars           # `cd VARNAME` works if VARNAME holds a path

# ── Completion behavior ──────────────────────────────────────────
# These affect how tab completion works at the cursor level.
# The actual completion rules (fuzzy matching, colors, etc.) are
# configured separately in 03-completion.zsh via zstyle.
setopt complete_in_word      # complete from cursor position, not end of word
setopt always_to_end         # move cursor to end of word after completion
setopt list_packed           # compact completion list (less vertical space)

# ── Globbing ─────────────────────────────────────────────────────
# extended_glob enables patterns like: ls ^*.log (everything except .log)
# glob_dots means *.txt also matches .hidden.txt (no need for .*txt)
setopt extended_glob         # extended globbing (#, ~, ^)
setopt glob_dots             # include dotfiles in glob matches

# ── History ──────────────────────────────────────────────────────
# These options control how commands are saved to and retrieved from
# the history file. The goal is: save everything, deduplicate
# aggressively, share across terminal sessions in real time.
#
# hist_ignore_all_dups vs hist_ignore_dups:
#   - hist_ignore_dups only skips CONSECUTIVE duplicates (a,a -> a)
#   - hist_ignore_all_dups removes ALL older duplicates when a new
#     one is added. This keeps your history clean over time.
#
# hist_ignore_space: prefix any command with a space to keep it out
# of history. Useful for commands containing secrets:
#   $ export API_KEY=sk-12345   <- saved to history (bad)
#   $  export API_KEY=sk-12345  <- NOT saved (note the leading space)
setopt hist_expire_dups_first  # expire duplicates first when trimming
setopt extended_history        # save timestamp and duration with each entry
setopt hist_ignore_all_dups    # remove older duplicate when new one added
setopt hist_ignore_space       # commands starting with space are not saved
setopt hist_find_no_dups       # don't show duplicates when searching
setopt hist_reduce_blanks      # remove extra whitespace from saved commands
setopt hist_save_no_dups       # don't write duplicates to the history file
setopt hist_verify             # show recalled history command before executing
setopt append_history          # append to history file, don't overwrite
setopt share_history           # share history across all open sessions in real time

# ── Miscellaneous ────────────────────────────────────────────────
setopt interactive_comments  # allow # comments in interactive shell
setopt no_beep               # silence the terminal bell
setopt rm_star_wait          # 10-second pause before executing 'rm *' (safety net)
setopt prompt_subst          # allow variable expansion in the prompt string
setopt long_list_jobs        # show PID in job notifications (bg/fg/jobs)

# ══════════════════════════════════════════════════════════════════
# History File Configuration
# ══════════════════════════════════════════════════════════════════
# 200,000 entries is generous. At ~50 commands/day, this gives you
# ~10 years of history. The file is typically 5-15MB at this size.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=200000
SAVEHIST=200000
