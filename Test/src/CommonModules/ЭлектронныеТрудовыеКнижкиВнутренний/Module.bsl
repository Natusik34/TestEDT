#Область СлужебныеПроцедурыИФункции

Функция РазрядКатегорияВидимость() Экспорт
	
	Возврат ЭлектронныеТрудовыеКнижкиБазовый.РазрядКатегорияВидимость();
	
КонецФункции

Функция КодПоРееструДолжностейВидимость() Экспорт
	
	Возврат ЭлектронныеТрудовыеКнижкиБазовый.КодПоРееструДолжностейВидимость();
	
КонецФункции

Процедура УстановитьОтборПараметровПолученияСотрудниковОрганизации(ПараметрыПолучения) Экспорт
	
КонецПроцедуры

Функция ИменаКадровыхДанныхСотрудниковДляНачалаУчета() Экспорт
	
	Возврат ЭлектронныеТрудовыеКнижкиБазовый.ИменаКадровыхДанныхСотрудниковДляНачалаУчета();
	
КонецФункции

Процедура ДополнитьМероприятияЭТКДаннымиРеестраКадровыхПриказов(ДанныеСотрудниковБезМероприятий) Экспорт
	
КонецПроцедуры

Процедура УточнитьЗапросПолученияДанныхНаНачалоУчета(Запрос) Экспорт
	
	ЭлектронныеТрудовыеКнижкиБазовый.УточнитьЗапросПолученияДанныхНаНачалоУчета(Запрос);
	
КонецПроцедуры

Функция КодДолжностиПоРееструГосударственнойСлужбы(Должность) Экспорт
	
	Возврат ЭлектронныеТрудовыеКнижкиБазовый.КодДолжностиПоРееструГосударственнойСлужбы(Должность);
	
КонецФункции

Функция МероприятияСотрудникаДо2020Года(Сотрудник, Организация) Экспорт
	
	Возврат ЭлектронныеТрудовыеКнижкиБазовый.МероприятияСотрудникаДо2020Года(Сотрудник, Организация);
	
КонецФункции

Функция ПредставлениеРазрядаКатегории(РазрядКатегория) Экспорт
	
	Возврат ЭлектронныеТрудовыеКнижкиБазовый.ПредставлениеРазрядаКатегории(РазрядКатегория);
	
КонецФункции

Процедура ЗаполнитьТипыОснованийУвольненияДляРегистрацииМероприятийТрудовойДеятельности(СписокОснований) Экспорт
	
	ЭлектронныеТрудовыеКнижкиБазовый.ЗаполнитьТипыОснованийУвольненияДляРегистрацииМероприятийТрудовойДеятельности(СписокОснований);
	
КонецПроцедуры

Процедура ЗаполнитьКодыТрудовыхФункцийПоДолжностям(ПараметрыОбновления = Неопределено) Экспорт
	
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеТрудовойФункцииВДолжности(ДолжностьОбъект, Отказ) Экспорт
	
	
КонецПроцедуры

Функция ИменаКадровыхДанныхДляФормированияМероприятий() Экспорт
	
	Возврат ЭлектронныеТрудовыеКнижкиБазовый.ИменаКадровыхДанныхДляФормированияМероприятий();
	
КонецФункции

Процедура ДополнитьСведениямиОТерриториальныхУсловиях(ДанныеМероприятия, ПараметрыФормирования, КадровыеДанныеСотрудников) Экспорт
	
	ЭлектронныеТрудовыеКнижкиБазовый.ДополнитьСведениямиОТерриториальныхУсловиях(ДанныеМероприятия, ПараметрыФормирования, КадровыеДанныеСотрудников)
	
КонецПроцедуры

Функция ТрудоваяФункцияПоКадровымДаннымДляФормированияМероприятий(КадровыеДанные) Экспорт
	
	Возврат ЭлектронныеТрудовыеКнижкиБазовый.ТрудоваяФункцияПоКадровымДаннымДляФормированияМероприятий(КадровыеДанные);
	
КонецФункции

#КонецОбласти