# To_do-List
<p>The repo present A daily Todo-List iOS app developed using swift5 and coredata to persist data.</p></br>
<p>The app help people organise their tasks on categories where each category is composed of a list of in progress tasks and done tasks.</p></br>
<p>The app is simple, intuitive and easy to use.</p></br>
Design pattern used : MVC and not MVVM since the app is not so complicated.

<h1> App functionalities : </h1>
<ul>
<li> Add a category.
<li> Rename or delete a category.
<li> Add a task inside a category with specifying the name, duration and the task priority.
<li> Select one task or multiple and mark them as done, they will be added to done list tasks.
<li> Check done tasks with having the ability to mark them as undone again.
<li> Sort tasks by priority.
<li> clear all the list of the in progress tasks or done tasks. 
<li> Rename or delete of a task.
<li> Search for a task by typing a string that is contained in the task name.
</ul>
  
<h2> Pods used : </h2>
<li> SwipeCellKit : to be able to swipe cells with a nice animation.
<li> ChameleonFramework: A color iOS framework.
  
<h1> The app UI </h1>

<h2>1)-Adding a task's category : </h2>
<p>By setting a name for the new category, the category added then gonna be stored in SQlite database using Coredata </p>


<br/>

<p align="middle" >
<img width="347" hspace="30" alt="Capture d’écran 2022-10-08 à 3 56 47 PM" src="https://user-images.githubusercontent.com/51541884/194713796-9fa85f8f-9b36-4294-bf4c-13344ef7bb24.png">     
<img width="352" alt="Capture d’écran 2022-10-08 à 3 57 39 PM" src="https://user-images.githubusercontent.com/51541884/194713872-32390978-c36f-4381-9da9-f0960c313e1b.png">
</p>

<h3> Renaming or deleting a category by swiping the cell : </h3>
<br/>

<p align="center">
  <img width="350" alt="Capture d’écran 2022-10-08 à 3 58 24 PM" src="https://user-images.githubusercontent.com/51541884/194713911-a744dec8-6739-49c0-a52a-603f452cdd0a.png">
</p>



<h2>2)-Adding a task to a category: </h2>

<br/>
<p float="left"  align="middle" >
<img width="351" hspace="30" alt="Capture d’écran 2022-10-08 à 4 04 37 PM" src="https://user-images.githubusercontent.com/51541884/194714193-5e258809-635a-4ede-8c5e-f900bd8424dc.png">   
<img width="351" alt="Capture d’écran 2022-10-08 à 4 05 23 PM" src="https://user-images.githubusercontent.com/51541884/194715933-be594c06-fc56-406e-b395-43d658bc8b8f.png">
</p>


<p float="left"  align="middle" >
<img width="346" hspace="15" alt="Capture d’écran 2022-10-10 à 7 44 28 PM" src="https://user-images.githubusercontent.com/51541884/194934220-689c3bdc-4725-4d36-b8ad-86fac5b1bbd4.png"> <b>The task will be added to the in progress tasks list.</b>
<img width="347" alt="Capture d’écran 2022-10-10 à 4 25 14 PM" src="https://user-images.githubusercontent.com/51541884/194934323-c921406a-1398-4485-bfa6-49555cd3d60c.png">

</p>


<h3> Renaming or deleting a Task by swiping the cell : </h3>

<br/>
<p align="center">
  <img width="348" alt="swipe cell" src="https://user-images.githubusercontent.com/51541884/194934477-8e2c34ff-3186-471a-ab46-2c4f49289205.png">
  
</p>




<h2>3)-Searching for a task : </h2>


<p align="center">
  <img width="344" alt="Capture d’écran 2022-10-08 à 4 48 09 PM" src="https://user-images.githubusercontent.com/51541884/194716023-b086386d-70af-458d-9ec3-d61d8f007a7c.png">
</p>


