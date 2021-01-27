# refugee-social-capital
R script for refugee social capital and integration project (uses ACS data).


Data citation: Steven Ruggles, Sarah Flood, Ronald Goeken, Josiah Grover, Erin Meyer, Jose Pacas and Matthew Sobek. IPUMS USA: Version 10.0 [dataset]. Minneapolis, MN: IPUMS, 2020. https://doi.org/10.18128/D010.V10.0.


This is code corresponds to the project NETWORKS, ACCESS AND COMPETITION: IMMIGRANT SOCIAL CAPITAL AND US REFUGEE INTEGRATION (11/2020- )

Abstract
What factors facilitate successful refugee integration? Might co-nationals, meaning individuals from the same country, support the integration process? It appears refugees are asking the same questions. Almost one fifth of refugees in the US opt for in-country secondary migration, often correlating with two factors: a destination’s relatively low unemployment rate and its existing co-national network. Combined, these pull factors can be understood to indicate sources of social capital to migrating refugees, who seek larger and higher quality co-national networks to provide greater access to resources. While extant quantitative studies hold that co-national social capital has a positive effect on immigrant economic integration, it is less clear how it affects non-economic integration types, which are also crucial to substantive community membership. Conducted within a social capital theory framework, this large-N comparative analysis utilizes a quasi-natural experiment to examine the effect of a state’s share of co-nationals and employment rate on three types of refugee integration: economic, linguistic and navigational. My results suggest that co-national social capital is influential in immigrant integration and that the variables that refugees often prioritize during secondary migration – low unemployment rate and existing co-national network – may effectively encourage multiple types of immigrant integration. This is the first large-N quantitative study to emphasize the relationship between co-national networks and non-economic immigrant integration outcomes.


Integration = B1*co-national size + B2*employment + B3*(co-national * employment) + A




----------------------------

Appendix C: Original ACS Survey Variables and Codes

1.	HHINCOME (Economic): HHINCOME reports the total money income of all household members age 15+ during the previous year. The amount should equal the sum of all household members' individual incomes, as recorded in the person-record variable INCTOT. The persons included were those present in the household at the time of the census or survey. Answers:
a.	(Continuous) A 7-digit numeric code which reports the total money income of all household members age 15+ during the previous year.

2.	EMPSTAT (Economic): EMPSTAT indicates whether the respondent was a part of the labor force – working or seeking work - and, if so, whether the person was currently unemployed.
a.	0 – N/A
b.	1 – Employed
c.	2 – Unemployed
d.	3 – Not in labor force

3.	SPEAKENG (Linguistic): Beginning in 1980, SPEAKENG indicates whether the respondent speaks only English at home, and also reports how well the respondent, who speaks a language other than English at home, speaks English. Answers:
a.	0 – N/A or blank
b.	1 – Does not speak English
c.	3 – Yes, speaks only English
d.	4 – Yes, speaks very well
e.	5 – Yes, speaks well
f.	6 – Yes, but not well

4.	CINETHH (Navigational): CINETHH reports whether any member of the household accesses the Internet. Here, "access" refers to whether or not someone in the household uses or connects to the Internet, regardless of whether or not they pay for the service.
a.	0 – N/A
b.	1 – Yes, with a subscription to an Internet Service
c.	2 – Yes, without a subscription to an Internet Service
d.	3 – No internet access at this house, apartment, or mobile home

5.	HCOVANY (Navigational): HCOVANY indicates whether persons had any health insurance coverage at the time of interview, as measured by employer-provided insurance(HINSEMP), privately purchased insurance (HINSPUR), Medicare (HINSCARE), Medicaid or other governmental insurance (HINSCAID), TRICARE or other military care (HINSTRI), or Veterans Administration-provided insurance (HINSVA). 
a.	1 – No health insurance coverage
b.	2 – With health insurance coverage



 
Appendix D: Scoring rules for integration variables

As originally presented in the IPL-12, the scoring rules assign values from 1 to 5 for each survey answer.  In the case of one survey question (healthcare insurance), the assigned values are 0 or 1. The dependent variable for each integration type is then found by summing the values of the survey answers provided by each respondent.

1.	Economic integration: The relative economic standing of a respondent household compared to an average local household as well as the respondent’s ability to afford expenses. 

The present research imitates the IPL-12 score by summing two variables included in the ACS data: a) household total annual income (before taxes and deductions), coded into 5 categories based on country’s gross median equivalized household income, which are assigned a score from 1-5, and b) recent employment status, coded according to ACS categories (assigned (1) for unemployed, (3) not in labor force, and (5) employed).  The total range for this variable is 2 to 10, inclusive.

For example, if a respondent reported a gross median income score of 4 and (d) employed, then the respondent’s total economic integration score is 9 (out of a possible 10).

2.	Linguistic integration: A respondent’s ability to understand others in the host country language(s). 

The original IPL-12 measurement includes the combined score (out of 5) of two metrics: the ability to read and the ability to speak. ACS data is only provided for a respondent’s ability to speak English. This variable was recoded and assigned a range from (1) for “does not speak English” to (5) for “only speaks English.” Rather than summing two variables, the present research uses a single metric, the respondent’s self-reported ability to speak English, as a substitute for both variables. The total range for this variable is 1 to 5, inclusive.

For example, if a respondent reported answer (e) “Yes, speaks well,” then the respondent’s total linguistic integration score is 3 (of a possible 5).

3.	Navigational integration: The extent to which a respondent possesses the knowledge and ability to access essential resources, such as healthcare, employment opportunities and legal assistance, as well as perform basic activities, such as send mail, pay income taxes, and abide by civilian laws. 

The original IPL-12 asks respondents to rate the difficulty of two essential tasks, seeing a doctor and searching for a job. Due to data limitations, the present research sums two substitute variables: a) access to the internet (assigned (1) for no access, (3) for shared  or public access, or (5) for personal access) and b) whether the respondent has healthcare insurance (coded 0 or 1). The total range for this variable is 1 to 6, inclusive.

For example, if a respondent reported answer (b) possessing subscription to an Internet Service and (a) no health insurance, their total navigational integration score is 5 (out of a possible 6).

