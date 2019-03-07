# Contacts
This app will dowload a list of contacts from the following endpoint https://gist.githubusercontent.com/pokeytc/e8c52af014cf80bc1b217103bbe7e9e4/raw/4bc01478836ad7f1fb840f5e5a3c24ea654422f7/contacts.json and show data as a card view.

- Use MVVM 
- Use NSUrslSession to download data
- Use size classes functionality to determine if the device is in Horizontal size class is Regular or Compact
- Use CollectionView to show data in different layout
- Layout done programetically now(have a plan to use snapkit)
- Show 20 contacts in first load and "Show More" button click will load another 20 until all data loaded.

This project is still in development, any suggestion would really appriciated.

# TODO: 
- Need to add UT for ViewModel
- Improve code with dependency injection for mocking

# Ouput Screen
<br />


- When the device trait collection horizontal size class is Compact the app will show data as following
![Alt text](/ScreenShot/potrait.png?raw=true "Optional Title")
<br />
<br />

- When the device trait collection horizontal size class is Regular the app will show data as following
![Alt text](/ScreenShot/landscape.png?raw=true "Optional Title")

# Installing
- This project is written in swift 4.2
- Minimum deployment target 9.0.
- works in both iPhone/iPad.


