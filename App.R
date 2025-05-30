library(shiny)
library(shinydashboard)
library(plotly)
library(dplyr)

source("R_scripts/fetch_data.R")
df_jobseekers <- data.frame(
	date = seq(as.Date("2024-01-01"), by = "month", length.out = 12),
	count = sample(10000:20000, 12)
)

df_vacancies <- data.frame(
	date = df_jobseekers$date,
	count = sample(3000:7000, 12)
)

df_trend <- data.frame(
	category = c("Men", "Women", "Youth", "Seniors"),
	value = sample(1000:5000, 4)
)

# UI
ui <- dashboardPage(
	dashboardHeader(title = "ADEM - Chiffres Clés"),
	dashboardSidebar(disable = TRUE),
	dashboardBody(
		fluidRow(
			uiOutput("demandeurBox"),
			uiOutput("residentsBox"),
			uiOutput("beneficiairesBox"),
			uiOutput("attenteBox"),
			uiOutput("totalPostesBox"),
			uiOutput("nouveauxPostesBox")
		),
		fluidRow(
			box(
				title = "Demandeurs d'emploi résidents", status = "primary", solidHeader = TRUE,
				width = 4,
				plotlyOutput("residencePlot")
			),
			box(
				title = "Demandeurs bénéficiant de l'indemnité de chômage complet", status = "success", solidHeader = TRUE,
				width = 4,
				plotlyOutput("indemnitePlot")
			),
			box(
				title = "Offres d'emploi tendence", status = "info", solidHeader = TRUE,
				width = 4,
				plotlyOutput("offrePlot")
			)
		)
	)
)

# Server
server <- function(input, output, session) {
	dem_1 <- reactive({
		tail(df_jobseekers$count, 1)
	})
	
	latest_jobseekers <- reactive({
		tail(df_jobseekers$count, 1)
	})
	
	latest_vacancies <- reactive({
		tail(df_vacancies$count, 1)
	})
	
	latest_month <- dem_gen %>%
		summarise(latest = max(Date)) %>%
		pull(latest)
	
	dem_latest <- dem_gen %>%
		filter(Date == latest_month)
	
	summary_by_gender <- dem_latest %>%
		group_by(Genre) %>%
		summarise(Total_Personnes = sum(Personnes))
	
	total_dem <- dem_latest %>%
		summarise(Total_Personnes = sum(Personnes))
	
	total_res <- dem_res %>%
		filter(Date == latest_month & Residence == "Résident") %>%
		summarise(Total_Residents = sum(Chomage_complet))
	
	#browser()
	
	output$demandeurBox <- renderUI({
		valueBox(
			value = total_dem,
			subtitle = "Demandeur Emploi",
			#icon = icon("users"),
			color = "aqua",
			width = 2
		)
	})
	
	output$residentsBox <- renderUI({
		valueBox(
			value = total_res,
			subtitle = "Résidents en mesure",
			#icon = icon("users"),
			color = "aqua",
			width = 2
		)
	})
	
	output$beneficiairesBox <- renderUI({
		valueBox(
			value = latest_vacancies(),
			subtitle = "Bénéficiaires du chômage",
			#icon = icon("briefcase"),
			color = "green",
			width = 2
		)
	})

	output$attenteBox <- renderUI({
		valueBox(
			value = latest_vacancies(),
			subtitle = "Indemnité d'attente",
			#icon = icon("briefcase"),
			color = "green",
			width = 2
		)
	})
	
	output$totalPostesBox <- renderUI({
		net <- latest_jobseekers() - latest_vacancies()
		valueBox(
			value = latest_jobseekers() - latest_vacancies(),
			subtitle = "Total postes vacants disponibles",
			#icon = icon("balance-scale"),
			color = "yellow",
			width = 2
		)
	})
	
	output$nouveauxPostesBox <- renderUI({
		net <- latest_jobseekers() - latest_vacancies()
		valueBox(
			value = latest_jobseekers() - latest_vacancies(),
			subtitle = "Nouveaux postes du mois",
			#icon = icon("balance-scale"),
			color = "yellow",
			width = 2
		)
	})
	output$residencePlot <- renderPlotly({
		plot_ly(df_jobseekers, x = ~date, y = ~count, type = 'scatter', mode = 'lines+markers',
						name = "Jobseekers") %>%
			layout(yaxis = list(title = ""), xaxis = list(title = ""))
	})
	
	output$indemnitePlot <- renderPlotly({
		plot_ly(df_vacancies, x = ~date, y = ~count, type = 'scatter', mode = 'lines+markers',
						name = "Vacancies", marker = list(color = 'forestgreen')) %>%
			layout(yaxis = list(title = ""), xaxis = list(title = ""))
	})
	
	output$offrePlot <- renderPlotly({
		plot_ly(df_vacancies, x = ~date, y = ~count, type = 'scatter', mode = 'lines',
						name = "Vacancies") %>%
			layout(yaxis = list(title = ""), xaxis = list(title = ""))
	})
}

shinyApp(ui, server)
