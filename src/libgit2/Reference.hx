package libgit2;
import cpp.ConstCharStar;
import cpp.RawPointer;
import libgit2.externs.LibGit2;

@:unreflective
@:access(libgit2.Repository)
@:access(libgit2.Oid)
class Reference extends Common {
    private var pointer:RawPointer<GitReference> = null;

    public var repository:Repository;
    public var name:String;
    
    public function new(repository:Repository, name:String = "HEAD") {
        super();
        this.repository = repository;
        this.name = name;
    }
    
    public var oid(get, null):Oid;
    private function get_oid():Oid {
        var oid = new Oid();
        var r = LibGit2.git_reference_name_to_id(oid.pointer, repository.pointer, name);
        checkError(r);
        return oid;
    }

    public function lookup() {
        var r = LibGit2.git_reference_lookup(RawPointer.addressOf(pointer), repository.pointer, name);
        checkError(r);
    }

    public var branchName(get, null):String;
    private function get_branchName():String {
        var head:RawPointer<GitReference> = null;
        var r = LibGit2.git_repository_head(RawPointer.addressOf(head), repository.pointer);
        checkError(r);
        if (!LibGit2.git_reference_is_branch(head)) {
            LibGit2.git_reference_free(head);
            throw 'not a branch';
        }
        var name:ConstCharStar = "";
        LibGit2.git_branch_name(RawPointer.addressOf(name), head);
        var s = new String(name);
        LibGit2.git_reference_free(head);
        return s;
    }
    
    public var commit(get, null):Commit;
    private function get_commit():Commit {
        var c = new Commit(repository);
        c.lookup(oid);
        return c;
    }
}