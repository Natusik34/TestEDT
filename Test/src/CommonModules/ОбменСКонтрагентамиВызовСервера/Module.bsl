#Область СлужебныеПроцедурыИФункции

Процедура УстановитьИспользованиеВнутреннегоЭДО(Использовать) Экспорт
	
	НастройкиЭДО.УстановитьИспользованиеВнутреннегоЭДО(Использовать);
	
КонецПроцедуры

// Устарела.
Функция КлючНастроекОтправкиОбъектаУчета(ОбъектУчета) Экспорт
	
	ОписаниеОбъектаУчета = ИнтеграцияЭДО.ОписаниеОбъектаУчета(ОбъектУчета);
	СтрокаОписания = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ОписаниеОбъектаУчета[0]);
	КлючНастроек = ЭлектронныеДокументыЭДО.КлючНастроекОтправкиОбъектаУчета(СтрокаОписания);
	Возврат КлючНастроек;
	
КонецФункции

#КонецОбласти