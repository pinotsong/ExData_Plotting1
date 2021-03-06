##setting the directory:
currentDirectory <- getwd()
newDirectory <- paste(currentDirectory,"/CourseProject1",sep="")
if(!file.exists("CourseProject1")){dir.create("CourseProject1")}
setwd(newDirectory)

##downloading, unzipping the data:
setInternet2()
file_train <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(file_train,"exdata_data_household_power_consumption.zip")
unzip("./exdata_data_household_power_consumption.zip", files = NULL, list = FALSE,junkpaths = FALSE,  unzip = "internal",setTimes = FALSE)



##Because the data are based on time series. 
##We can find the number of rows that match the conditions.
con <- file("./household_power_consumption.txt", "r")
line=readLines(con,n=1)
n <- 0
nrows <- 0
while( length(line) != 0 ) {
  n <- n+1
  line=readLines(con,n=1)
  line <- strsplit(line, ";")
  line <- as.array(line[[1]])
  
  if (as.character(line[1])=="1/2/2007"|as.character(line[1])=="2/2/2007"){
    skip <- n
    nrows <- nrows+1
  }
  
}
close(con)

##loading the data according to skip and nrows.
data <- read.table('./household_power_consumption.txt', header=T, sep=';', skip=skip-nrows+1, nrows=nrows)
header <- read.table('./household_power_consumption.txt', header=T, sep=';', nrows=1)
colnames(data) <- colnames(header)

##Making plot
data$Timestamp <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")
png(filename='./figures/plot2.png',width=480, height=480)
plot(data$Timestamp, data$Global_active_power, xlab="", ylab="Global Active Power(kilowatts)", type='l')
dev.off()
