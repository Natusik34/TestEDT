	
#Область СлужебныйПрограммныйИнтерфейс
	
Функция ПолучитьВыгружаемыеДанныеЖурналаУчетаСчетовФактур(Ссылка, УникальныйИдентификаторЖурнала) Экспорт

	ДокументОбъект = Ссылка.ПолучитьОбъект();
	
	ВыгружаемыеДанные = ДокументОбъект.ВыгрузитьДокумент(УникальныйИдентификаторЖурнала);
	
	Возврат ВыгружаемыеДанные;

КонецФункции

#КонецОбласти