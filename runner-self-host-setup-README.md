# Steps required for Adding self-hosted runner 

# Create a yaml file  to a repository

Create a yml file in our repo , to run yocto setup using selfhosted runner setup.

# Permissions to make images upload to release section :-

-  On GitHub.com, navigate to the main page of your repository.
-  Click on the "Settings" tab in the top-right corner.In the left sidebar, click on "Actions".
-  Go to "General" field in "Actions" tab.
-  Enable "Read and write permissions" in thw Workflow permissions.

![Screenshot from 2023-09-25 13-47-34](https://github.com/manojams/meta-openaia/assets/97679353/b919b0c6-6ffd-4020-882a-7bada7a0cb99)


# Adding a self-hosted runner to a repository

You can add self-hosted runners to a single repository. To add a self-hosted runner to a user repository, you must be the repository owner. 
For an organization repository, you must be an organization owner or have admin access to the repository

-  On GitHub.com, navigate to the main page of the repository.
-  Under your repository name, click  Settings.
-  In the left sidebar, click  Actions, then click Runners

![runner-github](https://github.com/manojams/meta-openaia/assets/97679353/b31ca003-c7d0-42c0-a685-b0cc82aaa825)


- Click New self-hosted runner.
  
- Select the operating system image and architecture of your self-hosted runner machine.
  
- You will see instructions showing you how to download the runner application and install it on your self-hosted runner machine.
  
Open a shell on your self-hosted runner machine and run each shell command in the order shown.

After completing the steps to add a self-hosted runner, the runner and its status are now listed under "Runners".

The self-hosted runner application must be active for the runner to accept jobs. 

When the runner application is connected to GitHub and ready to receive jobs, you will see the following message on the machine's terminal.

```shell
√ Settings Saved.

manoj:actions-runner$ ./run.sh

√ Connected to GitHub

Current runner version: '2.309.0'
2023-09-25 08:57:23Z: Listening for Jobs

```


