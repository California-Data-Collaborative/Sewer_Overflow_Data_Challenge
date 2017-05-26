The Complete Visualization Can be found here-

http://bit.ly/California_Sewage_Spills_ARGO

Please be patient as the visualization is hosted on an amazon aws free instance and may sometimes take about 30 seconds to load:)

The Visualization Contains four tabs-

1.California-
	Displays the spill Volume for the whole state of california.The radius of the circle signifies the volume of spill.

	The graphs for the whole state can be displayed by checking the show graphs checkbox and selecting the desired graph.The graphs can be described as:
		a.Consistent Spills-The number of Collection Systems that have been consistently getting spills by the number of months.In all "16" such collection systems are identified with spills throughout the period specified in the dataset and are included in the "Top_consistently_Spilling_CS.csv" file.
		b.Distribution By Spill Cause-Pie Chart that displays the distribution of spills with respect to causes.In general,
		"Root Intrusion" is identified to be the main cause of spills.
		c.Spill Requests By County-Bar graph to display the spills by each county."Sacramento" had the maximum number of spills over the years.
		d.Spill Voulme By Quantity-A scatterplot to display the total volume spilled,Total Volume Recovered,Total Volume reaching Land and Total Volume Reaching Surface Water by County.It was observed that "San Bernardino" was the highest with the most spill volume.

	The Graphs can be saved by clicking the small camera icon that appears on hovering above the graphs.

2.County-
	Displays the spill Volume and spill volume reaching surface water for the selected County.The radius of the circle signifies the volume of spill.

	The Graphs can be made visible by clicking the show graphs checkbox.
	Each County Contains the following Graphs:
		a.Distribution By Spill Cause for each county.
		b.Spill Volume By Year:Changes in the spill volume over the years for the selected county.
		c.Top 15 Collection System by spill requests : bar chart to display the top 15 collection systems with most spill cases for each county.
		d.Top 15 CS by volume:Bar chart to display the top 15 collection systems with most volume spilled for each county.
	Again,the Graphs can be saved by clicking the small camera icon that appears on hovering above the graphs.	
	Also,the map plots can be turned on or off based on the checkbox on the top right hand corner of the screen to display the desired value only.

3.Collection System-
	Displays the spill Volume,spill volume reaching surface water and the location of the spills for the selected Collection system.
	The radius of the circle signifies the volume of spill.

	The Graphs can be made visible by clicking the show graphs checkbox.
	Each Collection System Contains the following Graphs:
		a.Distribution By Spill Cause for each county.
		b.Frequency of spills over the years for each collection system.
		c.Spills By Date-scatter plot to display Spill volume,Spill volume reaching surface water,spill volume reaching land and spill volume recovered for each spill observed by the collection system.
		d.Analysis of Spills-The boxplot to analyse the Spill volume,Spill volume reaching surface water,spill volume reaching land and spill volume recovered for each collection System.
	Again,the Graphs can be saved by clicking the small camera icon that appears on hovering above the graphs.	
	Also,the map plots can be turned on or off based on the checkbox at the top right hand corner of the screen to display the desired value only.	

4.Tabular Data
	All Spills and their important info faced by the selected collection system.

Some more information like the weather of that particular place before the spill could really be helpful in predeterming potential spill areas.

All the graphs are interactive,i.e.,you can zoom in and out,select parts to display by clicking on the appropriate label and displays legends on hovering above them.

The graphs folder also contains some CSV files that identifies some of the top collection systems based on total spill Volume,Total impact(Spill volume - spill volume recovered),etc.


The Top_20.R and the consistent spills.R contains the R code that generates the above csv files.Please Make sure to set the approriate working directory for the input CSV files before running these.

The Application folder contains the server.R and ui.R files that are creating the visualization.

for queries and additional information.
contact-Bhavesh Motwani
		bmotwani@usc.edu
		3235409767
		Linkedin-https://www.linkedin.com/in/bhavesh-motwani


The Complete Visualization Can be found here-

http://bit.ly/California_Sewage_Spills_ARGO

Please be patient as the visualization is hosted on an amazon aws free instance and may sometimes take about 30 seconds to load:)

THANK YOU.