## tables

Welcome to HTI Student Portal

Access your academic information anytime, anywhere

## Getting Started

Feature StudentRreg{
Screens of the project: 

-HomeScreen : 
Search for students (Done), 
top 10 students (Done), 
login (Done but will be improved in updates),
Profile Screen (ON IT),

-Student Screen : 
Gpa and finsihed unites (Done but will be improved in updates),
academic morshed (Done), 
Finished Courses (Done but will be improved in updates), 

--Connected screens : 
Gpa Calculator Screen ,
Register a Course Screen , 
table Builder Screen , 

------------------------------------------

Objects : 
-Student (Queue : morshed as an Object): 
name , id , morshed* , finished courses , current courses 

Course (Done): 
name , id  , units 

requisted Course :
Student , Course 

-morshed : 
name , list of requisted Course
}
===============================================================
Feature MorshedRreg{
Screens of the project: 

-HomeScreen : 
login ,
Requestes from students ,
Search for students , 

-Student Screen : 
Gpa and finsihed unites ,
academic morshed , 
Finished Courses , 

--Connected screens : 
Gpa Calculator Screen ,
Register a Course Screen , 
table Builder Screen , 

------------------------------------------

Objects : 
-Student : 
name , id , morshed , finished courses , current courses 

Course : 
name , id  , units 

requisted Course :
Student , Course 

-morshed : 
name , list of requisted Course
}


!! DOT ENV UPDATE !!
start by using dart pub global run dotenv:new

and start typing your .env file

WEB_API_KEY=
WEB_MEASUREMENT_ID=
ANDROID_API_KEY=
APP_ID = 
MESSAGING_SENDER_ID=
PROJECT_ID=
AUTH_DOMAIN=
STORAGE_BUCKET=


UPCOMING : 
-TOP 5 with ComboBox of Years (2010 -> 2024) (TOP5 Bloc)

-Upload Students Screen (Excel Friendly) in data Folder: 
--CheckBox : 4 Columns OR 1 Column

if 4 :
    --TextArea : IDs Column
    --TextArea : Names Column
    --TextArea : Units Column
    --TextArea : GPAs Column
if 1:
    --TextArea : (ID , Name , Units , GPA) Columns

--TextArea : Courses(StudentID-CourseID) Columns

/* Columns Are Seprated By Space "	" ,  

Example : 

  List<String> students = 
  '''
32010022	ﺍﺣﻤﺪ ﺍﺑﺮﺍﻫﻴﻢ ﻋﺒﺪﺍﻟﻮﻫﺎﺏ ﺣﺮﺣﺶ	70	0.42
32010193	ﻳﺤﻴﻰ ﻳﺎﺳﺮ ﺭﻭﺑﻰ ﻣﺼﻄﻔﻰ ﺍﻟﺸﻴﺦ	148.5	1.12
32011316	ﻣﺼﻄﻔﻲ ﺣﺴﻦ ﻋﻠﻲ ﺣﺴﻴﻦ	160.5	1.27
32012158	ﺍﺣﻤﺪ ﺧﺎﻟﺪ ﻋﻠﻰ ﺍﺑﺮﺍﻫﻴﻢ	160.5	1.40
32012215	ﺍﺳﻼﻡ ﺣﺴﻦ ﻋﺒﺪﺍﻟﻌﺎﻝ ﺍﻟﺴﻴﺪ	127.5	1.41
  '''.trim().split('\n');
  for(String line in students){
    String id = line.split('	')[0];
    String name = line.split('	')[1];
    String units = line.split('	')[2];
    String gpa = line.split('	')[3];
    
    print("id : "+id+"\n"+"name : "+name);
    print("units : "+units+"\n"+"gpa : "+gpa+"\n");
    
  }

*/

--Button : Upload
TODO: Update or Create Users to the Firestore ,
      Check if lines Match or send error Exception

--Button : Preview
TODO: View The Students as a popup window with search feature
-----------------------------------------------------------------

Make Department Object and make the departements Extend it (Done)

Make Screen for All Ranked Students from 1 to inf for each year
(2010 -> 2024) (Done)

Make the Morshed Have Department (Done)

# Make Eng entity that extends doctor with having doctor id

# Upload the Doctors with there : 
-id(int format : 0->1->2->inf)
-login name(String)
-login pass(String)
-name(String)
-imgurl (optional)

# Upload the Doctors assiociates (eng) with there : 
-id(int format : 320xx)
-login name(String)
-login pass(String)
-name(String)
-doctor id(int)
-imgurl (optional)

# Todo List:
- optimize the department from and to json (Done) 
- Make MorshedDr and MorshedEng entites (Done)
- remove the list of requests entirly from the entity (Done)
- upload all the doctors and engs with new parameters to firestore (Done)
- Upload All the students with just doctor_id (Done)

- make a pop up for requesting course contains : (done)
  list of request you made with status
  a text field searching for courses
-removing requests (done)
-requests registered counter(done)


- make requests show in the feature morshed (doen)
- Make Search in Doctor Screen Shows only their students (done)


-Add Under Each Course in Morshed: 
-Number Of Students Wants it (done)
-Course Code and Units (done)


-Add Under Each Course in Student: 
-Course Code and Units (done)
-reason of rejection (done)

-make Eng MorshedScreen Work (done)

-In Student : 
-make Courses With Green Light or Red Light Unremovable (done)

-limit courses with units so : 
  gpa < 1 : 12 units
  gpa < 2 : 14 units
  gpa < 3 : 18 unuts
  gpa <= 4 : 21 units
  # Declined Courses are not considered but Accepted does



-Finish the Tree in the profile screen (done)
--upload the students with courses contains electiveName (done)
--fix the elective problem (done)

-Make the upload Screen !!!!!!! (done)
-Make upload student finishedCourses (done)
-Make the morshed upload Screen
-Fix Register Screen

-make admin account that can:
 see all requests and edit all requests, 
 see all morsheds and edit all morsheds, 
 see all students and edit all students, 
 uploadStudents and uploadMorsheds

-Remove Dummy Data file


Canceled (The Tree Replaced IT !!!)
{

-Replace AllCourses List of Courses with list of map of map<string , int> and course

string : the name of the list that course belongs to 
int : the number of courses needed from this list 

-Make Note That Course You About to Request you alredy finished it's list, map<string , int>['string']

-In Morshed : 
-Make Note For Courses from Finished Lists

}