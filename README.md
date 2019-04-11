# `myaws`
 
Making `aws-vault` easier.

Are you tired of constantly appending `aws-vault my-profile exec -- ...` in front of all of you `aws` commands?
There has to be a better way...

<img src="https://media.giphy.com/media/l0HlOrRj8sqK1xiJa/giphy.gif" />

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
    Updated context arn:aws:eks:us-east-6:390832203:cluster/mycluster in ~/.kube/config
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


## Notes

There are a few environment variables that you can override to change the behavior.
* `MYAWS_DEFAULT_PROFILE` : This will set your default profile used by `myaws`
* `MYAWS_PS1` : Override the PS1 for your shell prompt `myaws`



### Contributions 

Shout out to the devs over at [aws-vault](https://github.com/99designs/aws-vault)!
