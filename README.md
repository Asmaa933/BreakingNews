# Breaking News

## Use

### **Structure**:-

I used the MVVM structure with use cases to cleanly achieve separation of concern for the user interface from the application logic. By using this architecture it helped in
- Independent of UI: The UI can change easily, without changing the rest of the system as we can substitute the table view with a collection view and we will not have to touch our logic
- Independent of the database and network: I can easily change them without breaking business rules.
- Testable: The business rules can be tested without the UI, database, web server, or any other external element.

#### Data Flow
1. View(UI) calls a method from ViewModel.
2. ViewModel executes Use Case.
3. Use Case call network API and return the articles to viewModel.
5. Information flows back to the View(UI) where we display the list of items.

### **Caching**:- 
1. I used **UserDefauls** to cache simple configuration(user favorites and date of last caching)
2. I used **documents directory** to cache articles and refresh it every 15 minutes:
#### When thinking about persistence in iOS apps:
The first choice might be Core Data but Core Data is best used when we have a lot of relationships between our objects as it is primarily an object graph manager that happens to have a persistence layer, our second choice might be realm but in our case, the overhead work is not worth it so saving a .plist file to disk allows us to easily add, remove our model objects without much code and the code is more swift friendly and it’s easy to understand

### **Enums**:-

Using enum is very pretty as I can set the cases and extend these cases with variables, I used them in
- Managing view states 
- Listing differrent categories and countries 
- Build Alamofire network request

## Pods

- **Alamofire**: HTTP networking library to simplify common REST services.
- **SDWebImage**: Async image downloader with cache support.
- **DropDown**:  Design drop down.

## ScreenShots

<div>
<img src="https://user-images.githubusercontent.com/44899782/147391006-d7337814-3472-416d-9fa6-77eebb93de6c.png" width= "100">
<img src="https://user-images.githubusercontent.com/44899782/147391008-3b34c9a0-a5be-4373-acf0-86585a295451.png" width= "100">
<img src="https://user-images.githubusercontent.com/44899782/147391012-1aef8d3d-63b6-47a3-bbbe-ceeac9543874.png" width= "100">
<img src="https://user-images.githubusercontent.com/44899782/147391031-359704fe-fc54-409a-81b1-de0e2580d7cf.png" width= "100">
<img src="https://user-images.githubusercontent.com/44899782/147391043-6adc6ed5-ceb3-494b-9630-5c0aa22a661c.png" width= "100">
<img src="https://user-images.githubusercontent.com/44899782/147391048-94484bdb-4bd6-4a73-9ded-5fba7675d8e7.png" width="100">
<img src="https://user-images.githubusercontent.com/44899782/147391353-16cf41ce-622e-4747-b552-a6605bdc94ba.png" width="100">
<img src="https://user-images.githubusercontent.com/44899782/147391362-dc92230f-71c4-4fcd-a3a5-03afb1b70f73.png" width="100">
<img src="https://user-images.githubusercontent.com/44899782/147391367-6b5cbb64-4826-4b22-ac32-09421b781369.png" width="100">
</div>

## Video

https://user-images.githubusercontent.com/44899782/147393972-22a62ecf-856b-4e3a-aa64-59bd173ef655.mov

## Unit Test Coverage: 43.3%
<img src="https://user-images.githubusercontent.com/44899782/147397051-15185fb8-f8a9-4986-89f4-ca99335368db.png" width="500">







