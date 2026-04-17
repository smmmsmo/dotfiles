# ══════════════════════════════════════════════════════════════════
# Shell Options & History
# ══════════════════════════════════════════════════════════════════

# ── Directory navigation ─────────────────────────────────────────
setopt auto_cd               # type a dir name to cd into it
setopt auto_pushd            # every cd pushes onto the dir stack
setopt pushd_ignore_dups     # don't stack the same dir twice
setopt pushd_silent          # don't print the stack on pushd/popd
setopt cdable_vars           # cd VARNAME works if VARNAME holds a path

# ── Completion ───────────────────────────────────────────────────
setopt complete_in_word      # complete from cursor position
setopt always_to_end         # move cursor to end after completion
setopt list_packed           # compact completion list
setopt menu_complete         # auto-select first completion match

# ── Globbing ─────────────────────────────────────────────────────
setopt extended_glob         # extended patterns (#, ~, ^)
setopt glob_dots             # include dotfiles in glob matches
setopt null_glob             # no error when glob matches nothing

# ── History ──────────────────────────────────────────────────────
# hist_ignore_space: prefix a command with a space to exclude it
# from history — useful for commands containing secrets.
setopt extended_history        # save timestamp + duration per entry
setopt hist_expire_dups_first  # expire duplicates first when trimming
setopt hist_ignore_all_dups    # remove older duplicate on new entry
setopt hist_ignore_space       # leading-space commands not saved
setopt hist_find_no_dups       # no duplicates when searching
setopt hist_reduce_blanks      # strip extra whitespace before saving
setopt hist_save_no_dups       # don't write duplicates to file
setopt hist_verify             # show recalled command before executing
setopt append_history          # append, don't overwrite
setopt share_history           # share across all sessions in real time
setopt inc_append_history      # write entries as they are typed

# ── Miscellaneous ────────────────────────────────────────────────
setopt interactive_comments  # allow # comments in interactive shell
setopt no_beep               # silence the terminal bell
setopt rm_star_wait          # 10-second pause before `rm *`
setopt prompt_subst          # allow variable expansion in prompt
setopt long_list_jobs        # show PID in job notifications
setopt notify                # report job status immediately
setopt no_hup                # don't kill background jobs on exit
setopt no_check_jobs         # don't warn about running jobs on exit
setopt multios               # allow multiple redirections (tee-like)
setopt correct               # offer spelling corrections for commands
setopt no_correct_all        # but NOT for arguments (too noisy)

# ── History file ─────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=200000
SAVEHIST=200000

# Ctrl-W stops at path separators (removes one path component at a time)
WORDCHARS="${WORDCHARS//\/}"
# Also exclude = and : so Ctrl-W stops at env var assignments and URLs
WORDCHARS="${WORDCHARS//=/}"
WORDCHARS="${WORDCHARS//:/}"
