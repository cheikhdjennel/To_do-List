# To_do-List
<h3><b>The repo present A daily Todo-List iOS app developed using swift5 and coredata to persist data.</b></h3>
<p>-The app help people organise their tasks on categories where each category is composed of a list of in progress tasks and done tasks.</br> 
-The app is simple, intuitive and easy to use. </br>
-Design pattern used : MVC and not MVVM since the app is not so complicated.
</p>
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
<p>-By setting a name for the new category, the category added then gonna be stored in SQlite database using Coredata.</p>
<p>-Renaming or deleting a category by swiping the cell.</p>
<p>
<img width="280" hspace="5" alt="Capture d’écran 2022-10-08 à 3 56 47 PM" src="https://user-images.githubusercontent.com/51541884/194713796-9fa85f8f-9b36-4294-bf4c-13344ef7bb24.png">     
<img width="280" hspace="5" alt="Capture d’écran 2022-10-08 à 3 57 39 PM" src="https://user-images.githubusercontent.com/51541884/194713872-32390978-c36f-4381-9da9-f0960c313e1b.png"> 
<img width="240" alt="Capture d’écran 2022-10-08 à 3 58 24 PM" src="https://user-images.githubusercontent.com/51541884/194713911-a744dec8-6739-49c0-a52a-603f452cdd0a.png">



<h2>2)-Adding a task to a category: </h2>
<p>The task will be added to InProgress tasks list</p>
<p float="left"  align="middle" >
<img width="320" hspace="40" alt="Capture d’écran 2022-10-10 à 7 44 28 PM" src="https://user-images.githubusercontent.com/51541884/194934220-689c3bdc-4725-4d36-b8ad-86fac5b1bbd4.png"> 
<img width="320" alt="Capture d’écran 2022-10-10 à 4 25 14 PM" src="https://user-images.githubusercontent.com/51541884/194934323-c921406a-1398-4485-bfa6-49555cd3d60c.png">
</p>

  
<h2>2)-Mark one or multiple tasks as done : </h2>
<p>The marked tasks will be added to the done tasks list and deleted from the inprogress list</p>
<p float="left"  align="middle" >
<img width="320" hspace="40" alt="select done tasks" src="https://user-images.githubusercontent.com/51541884/194936169-dcfe7a5b-4b8c-4c5f-ab92-43063e73c7c1.png">
<img width="320" alt="Updated done tasks list" src="https://user-images.githubusercontent.com/51541884/194936264-3a2ac301-e697-4aab-99e0-4b1393586329.png">

</p>
    

<h2>3)-Clear the in progress or done tasks list - the tasks will be deleted from the DB : </h2>
<br/>
<p align="center">
<img width="320" alt="After clear All" src="https://user-images.githubusercontent.com/51541884/194936979-07003542-0d12-4005-bdb0-faa778341f8a.png">
</p>  
  
  
<h2>4)-Sort Tasks by priority : </h2>
<br/>
<p align="center">
  <img width="320" alt="sort by priority" src="https://user-images.githubusercontent.com/51541884/194937089-41d4fbdd-65aa-483d-b6fd-f62cac402633.png">
</p>
  
  
  
<h2>5)-Renaming or deleting a Task by swiping the cell : </h2>
<br/>
<p align="center">
  <img width="320" alt="swipe cell" src="https://user-images.githubusercontent.com/51541884/194934477-8e2c34ff-3186-471a-ab46-2c4f49289205.png">
</p>





<h2>6)-Searching for a task : </h2>
<p align="center">
  <img width="320" alt="Capture d’écran 2022-10-08 à 4 48 09 PM" src="https://user-images.githubusercontent.com/51541884/194716023-b086386d-70af-458d-9ec3-d61d8f007a7c.png">
</p>


