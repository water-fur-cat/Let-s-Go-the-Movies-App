# Let's Go the Movies
## Task: 
I improve this application that allows users to view information about different movies. <br>
We are provided with an application that provide most of the functionality, but we need to work on it to fixe some issues and make some improvement to the functionality and user interface. <br>
We update the application and style the application with a consistent color scheme. <br>
We add an additional filter to sort the results by release date (releaseDate in the iTunes API JSON). This allows the users to be able to easily identify new releases. <br>

## User Interface:
Main Page:
<br>
<img width="300" height="639" src="https://github.com/water-fur-cat/Let-s-Go-the-Movies-App/blob/main/main_page.jpg"/>
<br>
Add Filter:
<br>
<img width="300" height="639" src="https://github.com/water-fur-cat/Let-s-Go-the-Movies-App/blob/main/filter.jpg"/>
<br>
Result after filter:
<br>
<img width="300" height="639" src="https://github.com/water-fur-cat/Let-s-Go-the-Movies-App/blob/main/result.jpg"/>
<br>
Movie details:
<br>
<img width="300" height="639" src="https://github.com/water-fur-cat/Let-s-Go-the-Movies-App/blob/main/details.jpg"/>
<br>

## Process:
1. The UISearchBar in the navigation bar is not fully implemented to perform a search against the iTunes API. It currently only is set up to print out the text to console.
2. The search bar text should be used to query the iTunes API when the user taps the "Search" button.
3. Save the current search term to UserDefaults so that you can always recall the most recent search term.
4. The default search when the application launches should be the last search term the user performed. Make sure to update the search bar text property to show the term.
5. When the app is launched for the first time, use "love" as the default search term (for Saint Valentine's day).

## Reference：
* https://developer.apple.com/documentation/uikit/view_controllers/displaying_searchable_content_by_using_a_search_controller
* https://betterprogramming.pub/cache-images-in-a-uicollectionview-using-nscache-in-swift-5-b70ebf090521
* https://pspdfkit.com/blog/2021/ios-15-image-api/
* https://www.hackingwithswift.com/example-code/media/how-to-read-the-average-color-of-a-uiimage-using-ciareaaverage
* https://mobiraft.com/ios/swift/swift-recipe/get-average-colour-from-uiimage/
* https://www.cxyzjd.com/article/qq_32117417/82418430