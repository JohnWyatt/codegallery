/****** Object:  StoredProcedure [dbo].[GetRaces]    Script Date: 10/22/2008 07:37:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRaces]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetRaces]
GO
/****** Object:  StoredProcedure [dbo].[SetSectorTime]    Script Date: 10/22/2008 07:37:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SetSectorTime]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SetSectorTime]
GO
/****** Object:  StoredProcedure [dbo].[GetRaces]    Script Date: 10/22/2008 07:37:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRaces]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE GetRaces
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM Races;
END
' 
END
GO
/****** Object:  StoredProcedure [dbo].[SetSectorTime]    Script Date: 10/22/2008 07:37:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SetSectorTime]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SetSectorTime]
	@RaceId int,
	@SectorId int,
	@AthleteId int,
	@StartTime datetime,
	@EndTime datetime,
	@Duration int
AS
BEGIN
	--ensure ref tables are populated:
	if not exists (select 1 from Races where RaceId = @RaceId)
	 insert into Races(RaceId, RaceName) values(@RaceId, ''Unknown'');
	if not exists (select 1 from Sectors where SectorId = @SectorId)
	 insert into Sectors(SectorId, SectorName) values(@SectorId, ''Unknown'');
	if not exists (select 1 from Athletes where AthleteId = @AthleteId)
	 insert into Athletes(AthleteId, AthleteName) values(@AthleteId, ''Unknown'');

	--populate sector:
if exists (select 1 from SectorTimes where RaceId=@RaceId and SectorId=@SectorId and AthleteId=@AthleteId)
	update SectorTimes set Duration=@Duration where RaceId=@RaceId and SectorId=@SectorId and AthleteId=@AthleteId;
else
	insert into SectorTimes(RaceId, SectorId, AthleteId, StartTime, EndTime, Duration)
	 values(@RaceId, @SectorId, @AthleteId, @StartTime, @EndTime, @Duration);
END
' 
END
GO
