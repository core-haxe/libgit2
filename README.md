# libgit2
libgit2 externs for hxcpp

## Usage

Since LibGit2 is pretty low level, there are a set of haxe wrappers that, as well as handling pointers, also allow you to perform some high level git operations that dont exist in the core LibGit2 lib:

### Opening repository
```haxe
var repository = new Repository();
repository.open("C:\\Work\\Personal\\TestPrivateRepo\\");
// set user details for repo (only needed for authenticated operations, like push)
repository.user = new UserDetails("Ian Harrigan", "ianharrigan@hotmail.com", "[password]");
```

### Listing commits
```haxe
// list first 20 commits
for (commit in repository.commits("HEAD~20")) {
    trace(". " + commit.oid + " - " + commit.message + " - " + commit.committer.name + ", " + commit.committer.email);
}
```

### Getting status
```haxe
var status = repository.status();
for (entry in status) {
    trace(entry.diff.fileOld.path + " => " + entry.diff.fileNew.path);
    trace(entry.status + ", " + entry.isNew + ", " + entry.isModified + ", " + entry.isDeleted);
}
```

### Making commit
```haxe
// write some data to a file
File.saveContent(repository.path + "test_my_file.txt", "" + Date.now());

// add a change and create the commit
repository.addPath("test_my_file.txt");
repository.createCommit("test commit " + Date.now());

// push, upload and clean up
repository.push();
repository.stateCleanup();
repository.reset();
```
