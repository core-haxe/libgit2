package libgit2;

import cpp.RawPointer;
import libgit2.externs.LibGit2;
import libgit2.externs.LibGit2.GitRemote;

@:unreflective
@:access(libgit2.Repository)
class Remote extends Common {
    private var pointer:RawPointer<GitRemote> = null;
    
    public var repository:Repository;
    public var user:UserDetails;
    
    public function new(repository:Repository) {
        super();
        this.repository = repository;
    }
    
    public function lookup(name:String) {
        var r = LibGit2.git_remote_lookup(RawPointer.addressOf(pointer), repository.pointer, name);
        checkError(r);
    }
    
    public function fetch() {
        var remoteCallbacks = GitRemoteCallbacks.alloc();
        var r = LibGit2.git_remote_init_callbacks(RawPointer.addressOf(remoteCallbacks), LibGit2RemoteCallbacks.REMOTE_CALLBACKS_VERSION);
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }

        if (user != null) {
            remoteCallbacks.credentials = untyped __cpp__("&libgit2::Repository_obj::credentialsCallback");
        }

        var fetchOptions = GitFetchOptions.alloc();
        r = LibGit2.git_fetch_options_init(RawPointer.addressOf(fetchOptions), LibGit2FetchOptions.FETCH_OPTIONS_VERSION);
        var error = checkError(r, false);
        if (error != null) {
            throw error;
        }

        fetchOptions.callbacks = remoteCallbacks;

        var r = LibGit2.git_remote_fetch(pointer, null, RawPointer.addressOf(fetchOptions), null);
        checkError(r);
    }

    public function disconnect() {
        LibGit2.git_remote_disconnect(pointer);
    }
    
    public override function free() {
        LibGit2.git_remote_free(pointer);
    }
}