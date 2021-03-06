USE [master]
GO
/****** Object:  Database [Snacks]    Script Date: 9/10/2021 7:08:56 AM ******/
CREATE DATABASE [Snacks]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Snacks', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLSERVER\MSSQL\DATA\Snacks.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Snacks_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLSERVER\MSSQL\DATA\Snacks_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [Snacks] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Snacks].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Snacks] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Snacks] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Snacks] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Snacks] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Snacks] SET ARITHABORT OFF 
GO
ALTER DATABASE [Snacks] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Snacks] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Snacks] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Snacks] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Snacks] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Snacks] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Snacks] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Snacks] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Snacks] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Snacks] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Snacks] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Snacks] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Snacks] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Snacks] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Snacks] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Snacks] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Snacks] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Snacks] SET RECOVERY FULL 
GO
ALTER DATABASE [Snacks] SET  MULTI_USER 
GO
ALTER DATABASE [Snacks] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Snacks] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Snacks] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Snacks] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Snacks] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Snacks] SET QUERY_STORE = OFF
GO
USE [Snacks]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [Snacks]
GO
/****** Object:  UserDefinedFunction [dbo].[GetUnsignString]    Script Date: 9/10/2021 7:08:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetUnsignString](@strInput NVARCHAR(4000)) 
RETURNS NVARCHAR(4000)
AS
BEGIN     
    IF @strInput IS NULL RETURN @strInput
    IF @strInput = '' RETURN @strInput
    DECLARE @RT NVARCHAR(4000)
    DECLARE @SIGN_CHARS NCHAR(136)
    DECLARE @UNSIGN_CHARS NCHAR (136)

    SET @SIGN_CHARS       = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệếìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵýĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ'+NCHAR(272)+ NCHAR(208)
    SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeeeiiiiiooooooooooooooouuuuuuuuuuyyyyyAADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD'

    DECLARE @COUNTER int
    DECLARE @COUNTER1 int
    SET @COUNTER = 1
 
    WHILE (@COUNTER <=LEN(@strInput))
    BEGIN   
      SET @COUNTER1 = 1
      --Tim trong chuoi mau
       WHILE (@COUNTER1 <=LEN(@SIGN_CHARS)+1)
       BEGIN
     IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@strInput,@COUNTER ,1) )
     BEGIN           
          IF @COUNTER=1
              SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)-1)                   
          ELSE
              SET @strInput = SUBSTRING(@strInput, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)- @COUNTER)    
              BREAK         
               END
             SET @COUNTER1 = @COUNTER1 +1
       END
      --Tim tiep
       SET @COUNTER = @COUNTER +1
    END
    RETURN @strInput
END
GO
/****** Object:  Table [dbo].[Account]    Script Date: 9/10/2021 7:08:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[UserName] [nvarchar](100) NOT NULL,
	[DisplayName] [nvarchar](100) NOT NULL,
	[Password] [nvarchar](1000) NOT NULL,
	[Type] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bill]    Script Date: 9/10/2021 7:08:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bill](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[DateCheckIn] [date] NOT NULL,
	[DateCheckOut] [date] NULL,
	[idTable] [int] NOT NULL,
	[status] [int] NOT NULL,
	[discount] [int] NULL,
	[totalPrice] [float] NULL,
 CONSTRAINT [PK__Bill__3213E83FAF9BA86B] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BillInfo]    Script Date: 9/10/2021 7:08:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BillInfo](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idBill] [int] NOT NULL,
	[idFood] [int] NOT NULL,
	[count] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Food]    Script Date: 9/10/2021 7:08:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Food](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[idCategory] [int] NOT NULL,
	[price] [float] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FoodCategory]    Script Date: 9/10/2021 7:08:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FoodCategory](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TableFood]    Script Date: 9/10/2021 7:08:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TableFood](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[status] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Account] ([UserName], [DisplayName], [Password], [Type]) VALUES (N'Admin', N'Admin', N'0', 1)
INSERT [dbo].[Account] ([UserName], [DisplayName], [Password], [Type]) VALUES (N'K1', N'Kai', N'0', 0)
INSERT [dbo].[Account] ([UserName], [DisplayName], [Password], [Type]) VALUES (N'KD', N'Kaiii', N'2', 1)
INSERT [dbo].[Account] ([UserName], [DisplayName], [Password], [Type]) VALUES (N'Staff', N'Staff', N'0', 0)
GO
SET IDENTITY_INSERT [dbo].[Bill] ON 

INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice]) VALUES (26, CAST(N'2021-09-01' AS Date), CAST(N'2021-09-01' AS Date), 4, 1, 0, 84000)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice]) VALUES (1045, CAST(N'2021-09-01' AS Date), CAST(N'2021-09-01' AS Date), 3, 1, 0, 12000)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice]) VALUES (1046, CAST(N'2021-09-01' AS Date), CAST(N'2021-09-01' AS Date), 3, 1, 0, 12000)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice]) VALUES (1048, CAST(N'2021-09-05' AS Date), CAST(N'2021-09-05' AS Date), 4, 1, 0, 45000)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice]) VALUES (1050, CAST(N'2021-09-05' AS Date), CAST(N'2021-09-05' AS Date), 8, 1, 0, 12000)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice]) VALUES (1054, CAST(N'2021-09-06' AS Date), CAST(N'2021-09-09' AS Date), 4, 1, 0, 24000)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice]) VALUES (2057, CAST(N'2021-09-09' AS Date), CAST(N'2021-09-09' AS Date), 9, 1, 10, 48600)
SET IDENTITY_INSERT [dbo].[Bill] OFF
GO
SET IDENTITY_INSERT [dbo].[BillInfo] ON 

INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (1067, 1050, 1008, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (1071, 1054, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (2072, 2057, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (2073, 2057, 3, 2)
SET IDENTITY_INSERT [dbo].[BillInfo] OFF
GO
SET IDENTITY_INSERT [dbo].[Food] ON 

INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (1, N'Cá viên chiên', 1, 12000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (2, N'Bò viên chiên', 1, 12000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (3, N'Mì xào', 2, 15000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (4, N'Nui xào', 2, 15000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (5, N'7 Up', 3, 15000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (6, N'Trà sữa', 3, 20000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (1008, N'Trà Chanh', 7, 12000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (1009, N'Tôm viên chiên', 1, 15000)
SET IDENTITY_INSERT [dbo].[Food] OFF
GO
SET IDENTITY_INSERT [dbo].[FoodCategory] ON 

INSERT [dbo].[FoodCategory] ([id], [name]) VALUES (1, N'Chiên')
INSERT [dbo].[FoodCategory] ([id], [name]) VALUES (2, N'Xào')
INSERT [dbo].[FoodCategory] ([id], [name]) VALUES (3, N'Nước giải khát')
INSERT [dbo].[FoodCategory] ([id], [name]) VALUES (4, N'Nướng')
INSERT [dbo].[FoodCategory] ([id], [name]) VALUES (7, N'Trà Đá')
SET IDENTITY_INSERT [dbo].[FoodCategory] OFF
GO
SET IDENTITY_INSERT [dbo].[TableFood] ON 

INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (1, N'Bàn 0', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (2, N'Bàn 1', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (3, N'Bàn 2', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (4, N'Bàn 3', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (5, N'Bàn 4', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (6, N'Bàn 5', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (7, N'Bàn 6', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (8, N'Bàn 7', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (9, N'Bàn 8', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (10, N'Bàn 9', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (11, N'Bàn 10', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (14, N'Bàn 13', N'Có người')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (15, N'Bàn 0', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (16, N'Bàn 0', N'Trống')
SET IDENTITY_INSERT [dbo].[TableFood] OFF
GO
ALTER TABLE [dbo].[Account] ADD  DEFAULT (N'Staff') FOR [DisplayName]
GO
ALTER TABLE [dbo].[Account] ADD  DEFAULT ((0)) FOR [Password]
GO
ALTER TABLE [dbo].[Account] ADD  DEFAULT ((0)) FOR [Type]
GO
ALTER TABLE [dbo].[Bill] ADD  CONSTRAINT [DF__Bill__DateCheckI__33D4B598]  DEFAULT (getdate()) FOR [DateCheckIn]
GO
ALTER TABLE [dbo].[Bill] ADD  CONSTRAINT [DF__Bill__status__34C8D9D1]  DEFAULT ((0)) FOR [status]
GO
ALTER TABLE [dbo].[BillInfo] ADD  DEFAULT ((0)) FOR [count]
GO
ALTER TABLE [dbo].[Food] ADD  DEFAULT (N'Chưa đặt tên') FOR [name]
GO
ALTER TABLE [dbo].[Food] ADD  DEFAULT ((0)) FOR [price]
GO
ALTER TABLE [dbo].[FoodCategory] ADD  DEFAULT (N'Chưa đặt tên') FOR [name]
GO
ALTER TABLE [dbo].[TableFood] ADD  DEFAULT (N'Chưa có tên') FOR [name]
GO
ALTER TABLE [dbo].[TableFood] ADD  DEFAULT (N'Trống') FOR [status]
GO
ALTER TABLE [dbo].[Bill]  WITH CHECK ADD  CONSTRAINT [FK__Bill__status__35BCFE0A] FOREIGN KEY([idTable])
REFERENCES [dbo].[TableFood] ([id])
GO
ALTER TABLE [dbo].[Bill] CHECK CONSTRAINT [FK__Bill__status__35BCFE0A]
GO
ALTER TABLE [dbo].[BillInfo]  WITH CHECK ADD  CONSTRAINT [FK__BillInfo__count__398D8EEE] FOREIGN KEY([idBill])
REFERENCES [dbo].[Bill] ([id])
GO
ALTER TABLE [dbo].[BillInfo] CHECK CONSTRAINT [FK__BillInfo__count__398D8EEE]
GO
ALTER TABLE [dbo].[BillInfo]  WITH CHECK ADD FOREIGN KEY([idFood])
REFERENCES [dbo].[Food] ([id])
GO
ALTER TABLE [dbo].[Food]  WITH CHECK ADD FOREIGN KEY([idCategory])
REFERENCES [dbo].[FoodCategory] ([id])
GO
/****** Object:  StoredProcedure [dbo].[GetAccountByUserName]    Script Date: 9/10/2021 7:08:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[GetAccountByUserName]
@username nvarchar(100)
AS
BEGIN 
	SELECT * FROM dbo.Account WHERE UserName = @username
END
GO
/****** Object:  StoredProcedure [dbo].[GetListBillByDate]    Script Date: 9/10/2021 7:08:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetListBillByDate]
@checkIn date, @checkOut date
AS
BEGIN
	SELECT t.name AS [Tên bàn], b.totalPrice AS [Tổng tiền], DateCheckIn AS [Ngày vào], DateCheckOut AS [Ngày ra], discount [Giảm giá]
	FROM Bill AS b, TableFood AS t
	WHERE DateCheckIn >= @checkIn AND DateCheckOut <= @checkOut AND b.status = 1 AND t.id = b.idTable
END
GO
/****** Object:  StoredProcedure [dbo].[GetListBillByDateAndPage]    Script Date: 9/10/2021 7:08:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetListBillByDateAndPage]
@checkIn date, @checkOut date, @page INT
AS
BEGIN
	DECLARE @pageRows INT = 10
	DECLARE @selectRows INT = @pageRows 
	DECLARE @exceptRows INT = (@page - 1) * @pageRows
	;WITH BillShow AS ( SELECT b.id ,t.name AS [Tên bàn], b.totalPrice AS [Tổng tiền], DateCheckIn AS [Ngày vào], DateCheckOut AS [Ngày ra], discount [Giảm giá]
	FROM Bill AS b, TableFood AS t
	WHERE DateCheckIn >= @checkIn AND DateCheckOut <= @checkOut AND b.status = 1 AND t.id = b.idTable )

	SELECT TOP (@selectRows) * FROM BillShow WHERE id NOT IN (SELECT TOP(@exceptRows) id FROM BillShow)
END
GO
/****** Object:  StoredProcedure [dbo].[GetNumBillByDate]    Script Date: 9/10/2021 7:08:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetNumBillByDate]
@checkIn date, @checkOut date
AS
BEGIN

	SELECT COUNT(*)
	FROM Bill AS b, TableFood AS t
	WHERE DateCheckIn >= @checkIn AND DateCheckOut <= @checkOut AND b.status = 1 AND t.id = b.idTable
END
GO
/****** Object:  StoredProcedure [dbo].[GetTableList]    Script Date: 9/10/2021 7:08:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[GetTableList]
AS SELECT * FROM dbo.TableFood
GO
/****** Object:  StoredProcedure [dbo].[InsertBill]    Script Date: 9/10/2021 7:08:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[InsertBill]
@idTable INT
AS
BEGIN
 INSERT dbo.Bill (DateCheckIn, DateCheckOut, idTable, status, discount)
 VALUES (GETDATE(), NULL, @idTable, 0, 0)
END
GO
/****** Object:  StoredProcedure [dbo].[InsertBillInfo]    Script Date: 9/10/2021 7:08:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[InsertBillInfo]
@idBill INT, @idFood INT, @count INT
AS
BEGIN
	DECLARE @isExistsBillInfo INT
	DECLARE @foodCount INT = 1
	SELECT @isExistsBillInfo = id, @foodCount = bi.count 
		FROM dbo.BillInfo as bi
		WHERE idBill= @idBill AND idFood = @idFood
	IF (@isExistsBillInfo > 0)
	BEGIN
		DECLARE @newCount INT = @foodCount + @count
		IF(@newCount >0)
			UPDATE dbo.BillInfo SET count = @foodCount + @count WHERE idFood = @idFood
		ELSE
			DELETE dbo.BillInfo WHERE idBill = @idBill AND idFood = @idFood
	END
	ELSE	
		BEGIN 
			INSERT dbo.BillInfo (idBill, idFood, count)
			VALUES (@idBill, @idFood, @count)
		END	
END
GO
/****** Object:  StoredProcedure [dbo].[Snack_Login]    Script Date: 9/10/2021 7:08:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Snack_Login]
@userName nvarchar(100),
@passWord nvarchar(100)
AS
BEGIN
	SELECT * FROM  dbo.Account WHERE UserName = @userName AND Password = @passWord
END
GO
/****** Object:  StoredProcedure [dbo].[SwitchTable]    Script Date: 9/10/2021 7:08:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SwitchTable] 
@idTable1 int, @idTable2 int
AS BEGIN
	DECLARE @idFirstBill INT
	DECLARE @idSecondBill INT
	DECLARE @isFirstTableEmpty INT = 1
	DECLARE @isSecondTableEmpty INT = 1
	
	SELECT @idSecondBill = id FROM dbo.Bill WHERE idTable = @idTable2 AND status = 0
	SELECT @idFirstBill = id FROM dbo.Bill WHERE idTable = @idTable1 AND status = 0

	IF (@idFirstBill IS NULL)
	BEGIN
		INSERT dbo.Bill (DateCheckIn, DateCheckOut, idTable, status)
		VALUES (GETDATE(), NULL, @idTable1, 0)
		SELECT @idFirstBill = MAX(id) FROM dbo.Bill WHERE idTable = @idTable1 AND status = 0

	END
	SELECT @isFirstTableEmpty = COUNT(*) FROM BillInfo WHERE idBill = @idFirstBill
	IF (@idSecondBill IS NULL)
	BEGIN
		INSERT dbo.Bill (DateCheckIn, DateCheckOut, idTable, status)
		VALUES (GETDATE(), NULL, @idTable2, 0)
		SELECT @idSecondBill = MAX(id) FROM dbo.Bill WHERE idTable = @idTable2 AND status = 0
	END
	SELECT @isSecondTableEmpty = COUNT(*) FROM BillInfo WHERE idBill = @idSecondBill

	SELECT id INTO IDBillInfoTable FROM dbo.BillInfo WHERE idBill = @idSecondBill
	UPDATE dbo.BillInfo SET idBill = @idSecondBill WHERE idBill = @idFirstBill
	UPDATE dbo.BillInfo SET idBill = @idFirstBill WHERE id IN (SELECT * FROM IDBillInfoTable)
	DROP TABLE IDBillInfoTable
	IF(@isFirstTableEmpty = 0)
		UPDATE dbo.TableFood SET status = N'Trống' WHERE id = @idTable2
	IF(@isSecondTableEmpty = 0)
		UPDATE dbo.TableFood SET status = N'Trống' WHERE id = @idTable1

END
GO
/****** Object:  StoredProcedure [dbo].[UpdateAccount]    Script Date: 9/10/2021 7:08:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UpdateAccount] 
@userName NVARCHAR(100), @didplayName NVARCHAR(100), @password NVARCHAR(100), @newPassword NVARCHAR(100)
AS
BEGIN
	DECLARE @isRightPass INT = 0
	SELECT @isRightPass = COUNT(*) FROM dbo.Account WHERE UserName = @userName AND Password = @password
	IF(@isRightPass = 1)
	BEGIN
		IF(@newPassword = NULL OR @newPassword = '')
		BEGIN
			UPDATE Account SET DisplayName = @didplayName WHERE UserName = @userName
		END
		ELSE
			UPDATE Account SET DisplayName = @didplayName, Password = @newPassword WHERE UserName = @userName
		END
END
GO
USE [master]
GO
ALTER DATABASE [Snacks] SET  READ_WRITE 
GO
