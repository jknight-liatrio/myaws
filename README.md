# `myaws`
 
Making `aws-vault` easier.

Are you tired of constantly appending `aws-vault ...` in front of all of you `aws` commands?
Well now you don't have to. This is a tool to help with managing `aws-vault`.


## Usage

There are several usage modes for this tool.

1. Run as a shorter command

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
    joe$ kubectl auth can-i get all
    + /usr/local/bin/aws-vault exec my-value-profile -- kubectl auth can-i get all
    Warning: the server doesn't have a resource type 'all'
    no

    joe$ myaws eks update-kubeconfig --name=k
    + /usr/local/bin/aws-vault exec my-vault-profile -- aws eks update-kubeconfig --name=cluster1
    Updated context arn:aws:eks:us-east-6:390832203:cluster/mycluster in ~/.kube/config

    joe$ myaws -- kubectl auth can-i get all
    + /usr/local/bin/aws-vault exec my-vault-profile -- kubectl auth can-i get all
    Warning: the server doesn't have a resource type 'all'
    yes
    ``` 

2. Source the output into your bash shell to keep a profile loaded for the duration
of your bash session.

    Here's an example: 
    ```bash
    joe$ . myaws

    joe$ aws ec2 describe-hosts
    {
        "Hosts": []
    } 

    ```

3. Use `myaws` to create a new shell

    ```bash
    joe$ myaws --
    [my-vault-profile] joe$> kubectl auth can-i get all
    Warning: the server doesn't have a resource type 'all'
    yes

    ```
    
## Installing

To install `myaws` simply copy the executable into a location in your path.


## Notes

There are a few environment variables that you can override to change the behavior.
* `MYAWS_DEFAULT_PROFILE` : This will set your default profile used by `myaws`
* `MYAWS_PS1` : Override the PS1 for your shell prompt `myaws`



### Contributions 

Shout out to the devs over at [aws-vault](https://github.com/99designs/aws-vault)!
