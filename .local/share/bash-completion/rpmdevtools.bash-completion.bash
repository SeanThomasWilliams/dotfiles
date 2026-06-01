# bash completion for rpmdevtools
# Requires bash-completion >= 20080705 (for _filedir)

_rpmdev_uniqargs()
{
    local i j
    for i in ${!COMPREPLY[@]}; do
        for (( j=0; j < ${#COMP_WORDS[@]}; j++ )); do
            if [[ $j -ne $COMP_CWORD && \
                ${COMPREPLY[i]} == ${COMP_WORDS[j]} ]]; then
                unset COMPREPLY[i]
                break
            fi
        done
    done
}

_rpmdev_installed_packages()
{
    if declare -F _rpm_installed_packages &>/dev/null ; then
        _rpm_installed_packages
    elif declare -F _xfunc &>/dev/null ; then
        # bash-completion 1.90+ dynamic loading
        _xfunc rpm _rpm_installed_packages
    fi
}

_rpmdev_curprev()
{
    if declare -F _get_comp_words_by_ref &>/dev/null ; then
        _get_comp_words_by_ref cur prev
    else
        cur=$1 prev=$2
    fi
}

_rpmdev_rpmfiles()
{
    if [[ ${#@} -ne 0 ]] ; then # called directly as completion function
        local cur prev ; _rpmdev_curprev "$2" "$3"
    fi
    _filedir '[rs]pm'
    _rpmdev_uniqargs
}

_rpmdev_archives()
{
    if [[ ${#@} -ne 0 ]] ; then # called directly as completion function
        local cur prev ; _rpmdev_curprev "$2" "$3"
    fi
    _filedir '@([rs]pm|deb|zip|?([ejtw])ar|tzo|[glx7]z|bz2|lzma|lrz|lz4|t@(bz?(2)|[glx]z)|cpio|arj|zoo|cab|rar|ace|lha)'
    _rpmdev_uniqargs
}

complete -F _rpmdev_rpmfiles -o filenames rpmdev-checksig

complete -F _rpmdev_archives -o filenames \
    rpmdev-{cksum,md5,sha{1,224,256,384,512},sum}

_spectool()
{
    COMPREPLY=()

    local i
    for i in ${COMP_WORDS[@]} ; do
        [[ "$i" == -@(h|-help) ]] && return
    done

    local cur prev ; _rpmdev_curprev "$2" "$3"

    case $prev in
        -C|--directory)
            _filedir -d
            return
            ;;
        -s|--source|-p|--patch|-d|--define)
            # TODO: do better with these
            return
            ;;
    esac

    if [[ "$cur" == -* ]] ; then
        COMPREPLY=( $( compgen -W '--list-files --get-files --help --all
                                   --sources --patches --source --patch
                                   --define --directory --sourcedir --dry-run
                                   --force --debug' -- "$cur" ) )
        # No _uniqargs here due to --define, --source, --patch
    else
        _filedir spec
        _rpmdev_uniqargs
    fi
} &&
complete -F _spectool -o filenames spectool

_rpmdev_bumpspec()
{
    COMPREPLY=()

    local i
    for i in ${COMP_WORDS[@]} ; do
        [[ "$i" == -@(h|-help|v|-version) ]] && return
    done

    local cur prev ; _rpmdev_curprev "$2" "$3"

    [[ $prev == -@(c|-comment|u|-userstring) ]] && return

    if [[ "$cur" == -* ]] ; then
        COMPREPLY=( $( compgen -W '--help --comment --userstring --rightmost
                                   --verbose --version' -- "$cur" ) )
    else
        _filedir spec
        if [[ $cur != .* ]]; then
            for i in ${!COMPREPLY[@]}; do
                [[ ${COMPREPLY[i]} == .@(git|svn) ]] && unset COMPREPLY[i]
            done
        fi
    fi
    _rpmdev_uniqargs
} &&
complete -F _rpmdev_bumpspec -o filenames rpmdev-bumpspec

_rpmdev_rmdevelrpms()
{
    COMPREPLY=()

    local i
    for i in ${COMP_WORDS[@]} ; do
        [[ "$i" == -@(h|-help|v|-version) ]] && return
    done

    local cur prev ; _rpmdev_curprev "$2" "$3"

    [[ $prev == --@(qf|queryformat) ]] && return

    COMPREPLY=( $( compgen -W '--help --list-only --queryformat --yes
                               --version' -- "$cur" ) )
    _rpmdev_uniqargs
} &&
complete -F _rpmdev_rmdevelrpms rpmdev-rmdevelrpms

_rpmdev_setuptree()
{
    local cur prev ; _rpmdev_curprev "$2" "$3"

    if [[ "$cur" == -* ]] ; then
        COMPREPLY=( $( compgen -W '-d' -- "$cur" ) )
    fi
} &&
complete -F _rpmdev_setuptree rpmdev-setuptree

_rpmls()
{
    COMPREPLY=()

    local cur prev ; _rpmdev_curprev "$2" "$3"

    if [[ "$cur" == -* ]] ; then
        COMPREPLY=( $( compgen -W '-l' -- "$cur" ) )
        _rpmdev_uniqargs
        return
    fi

    [[ $cur != */* ]] && _rpmdev_installed_packages
    _rpmdev_rpmfiles
} &&
complete -F _rpmls -o filenames rpmls

_rpmdev_newspec()
{
    COMPREPLY=()

    local i
    for i in ${COMP_WORDS[@]} ; do
        [[ "$i" == -@(h|-help|v|-version) ]] && return
    done

    local cur prev ; _rpmdev_curprev "$2" "$3"

    case $prev in
        -o|--output)
            _filedir spec
            return
            ;;
        -t|--type)
            COMPREPLY=( $( command ls __SYSCONFDIR__/rpmdevtools/spectemplate-*.spec 2>/dev/null ) )
            COMPREPLY=( ${COMPREPLY[@]%.spec} )
            COMPREPLY=( ${COMPREPLY[@]#__SYSCONFDIR__/rpmdevtools/spectemplate-} )
            COMPREPLY=( $( compgen -W '${COMPREPLY[@]}' -- "$cur" ) )
            return
            ;;
        -r|--rpm-version)
            # 4.3: no constructs filtered
            COMPREPLY=( $( compgen -W '4.3 4.4 4.6 4.8 4.11 4.12' -- "$cur" ) )
            return
            ;;
    esac

    if [[ "$cur" == -* ]] ; then
        COMPREPLY=( $( compgen -W '--output --type --macros --rpm-version
            --help --version' -- "$cur" ) )
    else
        _filedir spec
    fi
    _rpmdev_uniqargs
} &&
complete -F _rpmdev_newspec -o filenames rpmdev-newspec

_rpminfo()
{
    COMPREPLY=()

    local i
    for i in ${COMP_WORDS[@]} ; do
        [[ "$i" == -@(h|-help) ]] && return
    done

    local cur prev ; _rpmdev_curprev "$2" "$3"

    case $prev in
        -o|--output)
            _filedir
            return
            ;;
        -T|--tmp-dir)
            _filedir -d
            return
            ;;
    esac

    if [[ "$cur" == -* ]] ; then
        COMPREPLY=( $( compgen -W '--help --verbose --quiet -qq --installed
                                   --executables --libraries --pic --no_pic
                                   --pie --no_pie --rpath --rpath_odd --split
                                   --test --output --tmp-dir' -- "$cur" ) )
        _rpmdev_uniqargs
        return
    fi

    [[ $cur != */* ]] && _rpmdev_installed_packages
    _rpmdev_rpmfiles
} &&
complete -F _rpminfo -o filenames rpminfo

_rpmdev_extract()
{
    COMPREPLY=()

    local i
    for i in ${COMP_WORDS[@]} ; do
        [[ "$i" == -@(h|v) ]] && return
    done

    local cur prev ; _rpmdev_curprev "$2" "$3"

    if [[ $prev == -C ]] ; then
        _filedir -d
        return
    fi

    if [[ "$cur" == -* ]] ; then
        COMPREPLY=( $( compgen -W '-q -f -C -h -v' -- "$cur" ) )
        _rpmdev_uniqargs
        return
    fi

    _rpmdev_archives
} &&
complete -F _rpmdev_extract -o filenames rpmdev-extract

_rpmdev_diff()
{
    COMPREPLY=()

    local i
    for i in ${COMP_WORDS[@]} ; do
        [[ "$i" == -@(h|-help|v|-version) ]] && return
    done

    local cur prev ; _rpmdev_curprev "$2" "$3"

    if [[ "$cur" == -* ]] ; then
        # TODO: add some diff options here
        COMPREPLY=( $( compgen -W '--contents --list --long-list --metadata
            --help --version' -- "$cur" ) )
        _rpmdev_uniqargs
        return
    fi

    _rpmdev_archives
} &&
complete -F _rpmdev_diff -o filenames rpmdev-diff

_rpmdev_vercmp()
{
    COMPREPLY=()

    local i
    for i in ${COMP_WORDS[@]} ; do
        [[ "$i" == -@(h|-help|u|-usage) ]] && return
    done

    local cur prev ; _rpmdev_curprev "$2" "$3"

    if [[ $cur == -* ]] ; then
        COMPREPLY=( $( compgen -W '--help' -- "$cur" ) )
    fi
} &&
complete -F _rpmdev_vercmp rpmdev-vercmp

# Local variables:
# mode: shell-script
# sh-basic-offset: 4
# sh-indent-comment: t
# indent-tabs-mode: nil
# End:
# ex: ts=4 sw=4 et filetype=sh
