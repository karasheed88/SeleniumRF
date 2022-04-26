# SeleniumRF

CICD Integration – Jenkins with Robot Framework

What is Jenkins ?
Term CICD is becoming so popular, let’s understand CICD with Jenkins.

Jenkins offers a simple way to set up a Continuous Integration (CI) or Continuous Delivery (CD), it provides environment for almost any combination of languages and source code repositories using pipelines, as well as automating other routine development tasks. While Jenkins doesn’t eliminate the need to create scripts for individual steps, it does give you a faster and more robust way to integrate your entire chain of builds, tests, and deployment tools than you can easily build yourself.

“Don’t break the nightly build!” is a cardinal rule in software development shops that post a freshly built daily product version every morning for their testers. Before Jenkins, the best a developer could do to avoid breaking the nightly build was to build and test carefully and successfully on a local machine before committing the code. But that meant testing one’s changes in isolation, without everyone else’s daily commits. There was no firm guarantee that the nightly build would survive one’s commits, automated test cases needs to be integrated with Jenkins, so that every build runs such crucial tests and provides stability status of the build.

Let’s learn how to integrate Jenkins with your Robot Framework scripts.

Prerequisite: Jenkins (Open source tool) – https://www.jenkins.io/

Jenkins Machine Configuration:
Login into the machine with Jenkins user
Install Robot Framework Jenkins Plugin http://wiki.jenkins-ci.org/display/JENKINS/Robot+Framework+Plugin on Jenkins Server
Run the below script on Jenkins Console

system.setProperty(“hudson.model.DirectoryBrowserSupport.CSP”,”sandbox allow-scripts; default-src ‘none’; img-src ‘self’ data: ; style-src ‘self’ ‘unsafe-inline’ data: ; script-src ‘self’ ‘unsafe-inline’ ‘unsafe-eval’ ;”)

Image for post

 

Jenkins Job Configuration:
Login to Jenkins Web application
Click New Item, Enter your job Name and Select Freestyle Project Type
Image for post
Add a description to your project
Image for post
Configure git to pull your automation code repository
Image for post
Configure build trigger as per your requirement
Image for post

Configure how the build environment should be set up before the build
Image for post

Configure to execute Robot test scripts via Shell scripts with below commands
python3 -m rflint — ignore LineTooLong [Project Root]

python3 -m robot.run — outputdir [report Location] [Test Location]

exit 0

Image for post

Finally, configure robot framework test result analysis for executed tests, Use Robot Framework Plugin as Post Build Action
Image for post

Click the Advanced button to get Advanced configuration view
Image for post

Jenkins Execution:
Now you can execute your tests via above created Jenkins job by triggering a build, Now if everything successful, you should able to see result details as in below screenshot
Image for post

Further, you can access the Robot Report, Robot Log files as HTML reports within Jenkins itself and figure out exactly what happens with your tests.
Image for post

Image for post

