# `myaws`
 
Making `aws-vault` easier.

Are you tired of constantly adding `aws-vault my-profile exec -- ...` in front of all of you `aws` commands?
There has to be a better way...

<img src="https://media.giphy.com/media/l0HlOrRj8sqK1xiJa/giphy.gif" />



`myaws` is a wrapper around for `aws-vault` that and easier way run the 
`aws-cli` without having to run the `aws-vault` command every time.

## Usage

There are several usage ways to run `myaws`.

1. Run as a shorter version of `aws-vault my-profile exec`.

    Running it with no arguments shows the current profiles.
    
    ```bash
    joe$ myaws
    Using aws profile: my-vault-profile

    Profile                  Credentials              Sessions
    =======                  ===========              ========
    my-vault-profile         my-vault-profile         - 
    my-vault-profile2        my-vault-profile2        -
    default                  -
    ```

    You can also run it as a substitute to the `aws` command.
    
    ```bash
    # Here we can't access our eks cluster because we have not authenticated
 
    joe$ kubectl auth can-i get all
    + /usr/local/bin/aws-vault exec my-value-profile -- kubectl auth can-i get all
    no
    ```
    
    Now we authenticate and setup our kube config.
    ```bash
    joe$ myaws eks update-kubeconfig --name=cluster
    + /usr/local/bin/aws-vault exec my-vault-profile -- aws eks update-kubeconfig --name=cluster1
    Updated context arn:aws:eks:us-east-6:332322203:cluster/mycluster in ~/.kube/config
    ```
    
    Now we can run kubectl run this instead of constantly typing `aws-vault my-profile exec` in front of everything.
    ```bash
    joe$ myaws -- kubectl auth can-i get all
    + /usr/local/bin/aws-vault exec my-vault-profile -- kubectl auth can-i get all
    yes
    ``` 

2. `source` the into your bash shell to keep a profile loaded for the duration
of your bash session.

    Here's an example: 
    ```bash
    
    joe$ source myaws

    joe$ aws ec2 describe-hosts
    {
        "Hosts": [
            "host1",
            "host2"
         ]
    } 
    
    joe$ kubectl auth can-i get all
    yes
    ```

3. Use `myaws` to create a new shell

    This will create a new shell with all of your aws credentials loaded.
    ```bash
    joe$ myaws --
    [my-vault-profile] joe$> kubectl auth can-i get all
    yes
    [my-vault-profile] joe$> aws ec2 describe-hosts
    {
        "Hosts": [
            "host1",
            "host2"
         ]
    } 
 
    # To return to your previou shell, just exit
    [my-vault-profile] joe$> exit 
    joe$ 

    ```
    
## Installing

To install `myaws` simply copy the executable into a location in your path.

```bash
# make a directory for helper executables
$ mkdir ~/.bin

# Add your executable helper into to your PATH
$ echo 'export PATH="$PATH:$HOME/.bin"' >> ~/.bash_profile

# copy myaws into your helper executables folder 
$ cp myaws ~/.bin/myaws

# make sure that myaws is executable
$ chmod +x myaws
```

### Adding bash completion

You can add complete bash completion to `myaws` so that you get the same
completion from the `aws` command by doing the following.

* Copy the `myaws_completer` int your `~/.bin` directory and make it exectuable

```bash
$ cp completion_helpers/myaws_completer ~/.bin/myaws_completer
$ chmod +x ~/.bin/myaws_completer
```

* After you've installed the `myaws_completer`, add the following to your `~/.bash_profile`
right below where you add `~/.bin/` to your `PATH`.

```bash
# ~/.bash_profile

export PATH="$PATH:$HOME/.bin"
# Setup completion for myaws
if [[ $(type -t compopt) = "builtin" ]]; then
    complete -o default -C myaws_completer myaws
else
    complete -o default -o nospace -C myaws_completer myaws
fi
```

Thats it! Now just tab-complete to your hearts desire.

```bash
$ myaws eks <tab> <tab>
create-cluster      delete-cluster      describe-cluster    list-clusters       update-kubeconfig   wait
```

# Using `k`

`k` is wrapper around kubectl that uses `myaws` to handle your kubeconfig-context.
Instead of aliasing `kubectl` to `myaws -- kubectl`, try using `k`. `k` will check
your kube-context each time that your run `k` and try to use the appropriate command
before it.

To install `k` follow similar steps to installing `myaws`.

```bash
# copy myaws into your helper executables folder 
$ cp k ~/.bin/k

# make sure that myaws is executable
$ chmod +x k
```

### Setting up `k` tab completion

Make a bash_complete directory, move the `k.bash_completion` script into that directory
and `source` it in your `~/.bash_profile`

```bash
$ mkdir ~/.bash_completion.d
$ cp completion_helpers/k.bash_completion ~/.bash_completion.d/k.bash_completion
$ echo 'if [ -f "${HOME}/.bash_completion.d/k.bash_completion" ]; then . "${HOME}/.bash_completion.d/k.bash_completion"; fi ' >> ~/.bash_profile

```

## Notes

There are a few environment variables that you can override to change the behavior.
* `MYAWS_DEFAULT_PROFILE` : This will set your default profile used by `myaws`
* `MYAWS_PS1` : Override the PS1 for your shell prompt `myaws`



### Contributions 

Shout out to the devs over at [aws-vault](https://github.com/99designs/aws-vault)!
