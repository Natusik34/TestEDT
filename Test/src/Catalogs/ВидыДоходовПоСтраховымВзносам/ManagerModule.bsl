#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если НЕ Параметры.Отбор.Свойство("Ссылка") 
		ИЛИ ТипЗнч(Параметры.Отбор.Ссылка) = Тип("ФиксированныйМассив") Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("НеДоступныеЭлементы", Справочники.ВидыДоходовПоСтраховымВзносам.НеДоступныеЭлементыПоЗначениямФункциональныхОпций());
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ВидыДоходовПоСтраховымВзносам.Ссылка
			|ИЗ
			|	Справочник.ВидыДоходовПоСтраховымВзносам КАК ВидыДоходовПоСтраховымВзносам
			|ГДЕ
			|	НЕ ВидыДоходовПоСтраховымВзносам.Ссылка В (&НеДоступныеЭлементы)
			|	И ВидыДоходовПоСтраховымВзносам.Ссылка В(&СсылкиОтбора)";
			
		Если Параметры.Отбор.Свойство("Ссылка") Тогда
			Запрос.УстановитьПараметр("СсылкиОтбора", Параметры.Отбор.Ссылка);
		Иначе
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "И ВидыДоходовПоСтраховымВзносам.Ссылка В(&СсылкиОтбора)", "");
		КонецЕсли;
		
		МассивДоступныхЭлементов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		Параметры.Отбор.Вставить("Ссылка", Новый ФиксированныйМассив(МассивДоступныхЭлементов));
		
	КонецЕсли; 
	
	ДанныеВыбораБЗК.ЗаполнитьДляКлассификатораСПорядкомПоДопРеквизиту(
		Справочники.ВидыДоходовПоСтраховымВзносам,
		ДанныеВыбора, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

Процедура НачальноеЗаполнение() Экспорт
	
	Если ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьВидыДоходовПоСтраховымВзносам();
	
КонецПроцедуры


Процедура ЗаполнитьВидыДоходовПоСтраховымВзносам()

	ОписатьВидДоходаПоСтраховымВзносам("НеЯвляетсяОбъектом",												
		НСтр("ru='Доходы, не являющиеся объектом обложения страховыми взносами'"),																		Ложь, 	Ложь,	Ложь,	Ложь,	8); 
	ОписатьВидДоходаПоСтраховымВзносам("НеОблагаетсяЦеликом",												
		НСтр("ru='Доходы, целиком не облагаемые страховыми взносами, кроме пособий за счет ФСС и денежного довольствия военнослужащих'"),				Ложь, 	Ложь, 	Ложь, 	Ложь,	2); 
	ОписатьВидДоходаПоСтраховымВзносам("ПособияЗаСчетФСС",													
		НСтр("ru='Государственные пособия обязательного социального страхования, выплачиваемые за счет ФСС'"),											Ложь, 	Ложь, 	Ложь, 	Ложь,	4);
	ОписатьВидДоходаПоСтраховымВзносам("ПособияЗаСчетФСС_НС",												
		НСтр("ru='Государственные пособия по обязательному страхованию от несчастных случаев и профзаболеваний'"),										Ложь, 	Ложь, 	Ложь, 	Ложь,	5);
	ОписатьВидДоходаПоСтраховымВзносам("ДенежноеДовольствиеВоеннослужащих",									
		НСтр("ru='Денежное довольствие военнослужащих и приравненных к ним лиц рядового и начальствующего состава МВД и других ведомств'"),				Ложь, 	Ложь, 	Ложь, 	Ложь,	19);
	ОписатьВидДоходаПоСтраховымВзносам("НеОблагаетсяЦеликомПрокуроров",										
		НСтр("ru='Доходы прокуроров, следователей и судей, целиком не облагаемые страховыми взносами'"),												Ложь,	Ложь, 	Ложь, 	Ложь,	21, , , , Истина); 
	
	ОписатьВидДоходаПоСтраховымВзносам("ОблагаетсяЦеликом",													
		НСтр("ru='Доходы, целиком облагаемые страховыми взносами'"),																					Истина, Истина, Истина, Истина,	 1, , , Истина);
	ОписатьВидДоходаПоСтраховымВзносам("ДенежноеСодержаниеПрокуроров",										
		НСтр("ru='Денежное содержание прокуроров, следователей и судей, не облагаемое страховыми взносами на ОПС'"),										Ложь, 	Истина, Истина, Истина,	20, , , Истина, Истина); 
	
	ОписатьВидДоходаПоСтраховымВзносам("КомпенсацииОблагаемыеВзносами",										
		НСтр("ru='Возмещаемые ФСС компенсации, облагаемые страховыми взносами'"),																		Истина, Истина, Истина, Истина,	 9, , , Истина);
	ОписатьВидДоходаПоСтраховымВзносам("КомпенсацииОблагаемыеВзносамиПрокуроров",							
		НСтр("ru='Возмещаемые ФСС компенсации, облагаемые страховыми взносами, выплачиваемые прокурорам, следователям и судьям'"),						Ложь, 	Истина, Истина, Истина, 24, , , Истина, Истина); 
	ОписатьВидДоходаПоСтраховымВзносам("Матпомощь",															
		НСтр("ru='Материальная помощь, облагаемая страховыми взносами частично'"),																		Истина, Истина, Истина, Истина,	 6,	Истина, , Истина);
	ОписатьВидДоходаПоСтраховымВзносам("МатпомощьПрокуроров",												
		НСтр("ru='Материальная помощь прокуроров, следователей и судей, облагаемая страховыми взносами частично'"),										Ложь, 	Истина, Истина, Истина,	22,	Истина, , Истина, Истина); 
	ОписатьВидДоходаПоСтраховымВзносам("МатпомощьПриРожденииРебенка",										
		НСтр("ru='Материальная помощь при рождении ребенка, облагаемая страховыми взносами частично'"),													Истина, Истина, Истина, Истина,	 7,	Истина, , Истина);
	ОписатьВидДоходаПоСтраховымВзносам("МатпомощьПриРожденииРебенкаПрокуроров",								
		НСтр("ru='Материальная помощь при рождении ребенка прокурорам, следователям и судьям, облагаемая страховыми взносами частично'"),				Ложь, 	Истина, Истина, Истина,	23,	Истина, , Истина, Истина); 
	ОписатьВидДоходаПоСтраховымВзносам("ДоходыСтудентовЗаРаботуВСтудотрядеПоТрудовомуДоговору",				
		НСтр("ru='Доходы студентов за работу в студотряде по трудовому договору'"),																		Ложь,	Истина, Истина, Истина,	25, , , Истина); 

	ОписатьВидДоходаПоСтраховымВзносам("ДоходыСтудентовЗаРаботуВСтудотрядеПоГражданскоПравовомуДоговору",	
		НСтр("ru='Доходы студентов за работу в студотряде по гражданско-правовому договору'"),															Ложь, 	Истина, Ложь, 	Ложь,	26, , , Истина);
	
	ОписатьВидДоходаПоСтраховымВзносам("ДоговорыГПХ",														
		НСтр("ru='Договоры гражданско-правового характера'"),																							Истина,	Истина, Ложь, 	Ложь,	 3, , , Истина); 
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеАудиовизуальныеПроизведения",								
		НСтр("ru='Создание аудиовизуальных произведений (видео-, теле- и кинофильмов)'"),																Истина,	Истина, Ложь, 	Ложь,	12,	Истина,	Истина, Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеГрафическиеПроизведения",									
		НСтр("ru='Создание художественно-графических произведений, фоторабот для печати, произведений архитектуры и дизайна'"),							Истина, Истина, Ложь, 	Ложь,	14,	Истина,	Истина, Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеДругиеМузыкальныеПроизведения",							
		НСтр("ru='Создание других музыкальных произведений, в том числе подготовленных к опубликованию'"),												Истина, Истина, Ложь, 	Ложь,	13,	Истина,	Истина, Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеИсполнениеПроизведений",									
		НСтр("ru='Исполнение произведений литературы и искусства'"),																					Истина,	Истина, Ложь, 	Ложь,	10,	Истина,	Истина, Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеЛитературныеПроизведения",									
		НСтр("ru='Создание литературных произведений, в том числе для театра, кино, эстрады и цирка'"),													Истина, Истина, Ложь, 	Ложь,	15,	Истина,	Истина, Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеМузыкальноСценическиеПроизведение",						
		НСтр("ru='Создание музыкально-сценических произведений (опер, балетов и др.), симфонических, хоровых, камерных, оригинальной музыки для кино и др.'"),	Истина,	Истина, Ложь, 	Ложь,	16,	Истина,	Истина, Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеНаучныеТруды",												
		НСтр("ru='Создание научных трудов и разработок'"),																								Истина,	Истина, Ложь, 	Ложь,	17,	Истина,	Истина, Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеОткрытия",													
		НСтр("ru='Открытия, изобретения и создание промышленных образцов (процент суммы дохода, полученного за первые два года использования)'"),		Истина, Истина, Ложь,	Ложь,	11,	Истина,	Истина, Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеСкульптуры",												
		НСтр("ru='Создание произведений скульптуры, монументально- декоративной живописи, декоративно-прикладного и оформительского искусства, станковой живописи и др.'"),	Истина,	Истина, Ложь, 	Ложь,	18,	Истина,	Истина, Истина);
	
	ОписатьВидДоходаПоСтраховымВзносам("ОблагаетсяЦеликомНеОблагаемыеФСС_НС",								
		НСтр("ru='Доходы, целиком облагаемые страховыми взносами на ОПС, ОМС и соц.страхование, не облагаемые взносами на страхование от несчастных случаев'"),				Истина, Истина, Истина, Ложь,	27, , , Истина);
	ОписатьВидДоходаПоСтраховымВзносам("ДенежноеСодержаниеПрокуроровНеОблагаемыеФСС_НС",					
		НСтр("ru='Денежное содержание прокуроров, следователей и судей, не облагаемое страховыми взносами на ОПС и взносами на страхование от несчастных случаев'"),			Ложь, 	Истина, Истина, Ложь,	28, , , Истина, Истина); 
	ОписатьВидДоходаПоСтраховымВзносам("ДоговорыГПХОблагаемыеФСС_НС",										
		НСтр("ru='Договоры гражданско-правового характера, облагаемые взносами на страхование от несчастных случаев'"),									Истина,	Истина, Ложь, 	Истина,	29, , , Истина); 
	
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеАудиовизуальныеПроизведенияОблагаемыеФСС_НС",				
		НСтр("ru='Создание аудиовизуальных произведений (видео-, теле- и кинофильмов), облагаемые взносами на страхование от несчастных случаев'"),		Истина,	Истина, Ложь, 	Истина,	32,	Истина,	Истина, Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеГрафическиеПроизведенияОблагаемыеФСС_НС",					
		НСтр("ru='Создание художественно-графических произведений, фоторабот для печати, произведений архитектуры и дизайна, обл.взносами на страхование от несч.случаев'"),Истина, Истина, Ложь, 	Истина,	34,	Истина,	Истина, Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеДругиеМузыкальныеПроизведенияОблагаемыеФСС_НС",			
		НСтр("ru='Создание других музыкальных произведений, в том числе подготовленных к опубликованию, облагаемые взносами на страхование от несчастных случаев'"),		Истина, Истина, Ложь, 	Истина,	33,	Истина,	Истина, Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеИсполнениеПроизведенийОблагаемыеФСС_НС",					
		НСтр("ru='Исполнение произведений литературы и искусства, облагаемые взносами на страхование от несчастных случаев'"),							Истина,	Истина, Ложь, 	Истина,	30,	Истина,	Истина, Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеЛитературныеПроизведенияОблагаемыеФСС_НС",					
		НСтр("ru='Создание литературных произведений, в том числе для театра, кино, эстрады и цирка, облагаемые взносами на страхование от несчастных случаев'"),			Истина, Истина, Ложь, 	Истина,	35,	Истина,	Истина, Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеМузыкальноСценическиеПроизведениеОблагаемыеФСС_НС",		
		НСтр("ru='Создание музыкально-сценических произведений (опер, балетов и др.), симфонических, хоровых и др., обл.взносами на страхование от несч.случаев'"),			Истина,	Истина, Ложь, 	Истина,	36,	Истина,	Истина, Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеНаучныеТрудыОблагаемыеФСС_НС",								
		НСтр("ru='Создание научных трудов и разработок, облагаемые взносами на страхование от несчастных случаев'"),									Истина,	Истина, Ложь, 	Истина,	37,	Истина,	Истина, Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеОткрытияОблагаемыеФСС_НС",									
		НСтр("ru='Открытия, изобретения и создание промышленных образцов, облагаемые взносами на страхование от несчастных случаев'"),		 			Истина,	Истина, Ложь, 	Истина,	31,	Истина,	Истина, Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеСкульптурыОблагаемыеФСС_НС",								
		НСтр("ru='Создание произведений скульптуры, монументально-декоративной живописи и др., облагаемые взносами на страхование от несчастных случаев'"),		Истина,	Истина, Ложь, 	Истина,	38,	Истина,	Истина, Истина);
	
	ДобавитьВыплатыПоДоговорамОпеки();
	ДобавитьВыплатыПоДоговорамОпекиОблагаемыеФССНС();
	ДобавитьВыплатыПоДоговорамСтудентам();
	ДобавитьКоронавирусныеСубсидии();
	
КонецПроцедуры

Процедура ДобавитьВыплатыПоДоговорамОпеки() Экспорт 
	
	ОписатьВидДоходаПоСтраховымВзносам("ВыплатыПоДоговорамОпекиПолучающимСтраховыеПенсии",                  
		НСтр("ru='Выплаты по договорам опеки и попечительства лицам, получающим страховые пенсии'"), Ложь, Истина, Ложь, Ложь, 42); 
	
КонецПроцедуры

Процедура ДобавитьВыплатыПоДоговорамОпекиОблагаемыеФССНС() Экспорт 
	
	ОписатьВидДоходаПоСтраховымВзносам("ВыплатыПоДоговорамОпекиПолучающимСтраховыеПенсииОблагаемыеФСС_НС",                  
		НСтр("ru='Выплаты по договорам опеки и попечительства лицам, получающим страховые пенсии, облагаемые взносами на страхование от несчастных случаев'"), Ложь, Истина, Ложь, Истина, 44); 
	
КонецПроцедуры

Процедура ДобавитьВыплатыПоДоговорамСтудентам() Экспорт

	ОписатьВидДоходаПоСтраховымВзносам("ДоходыСтудентовЗаРаботуВСтудотрядеПоДоговоруГПХОблагаемыеФСС_НС",	
		НСтр("ru='Доходы студентов за работу в студотряде по гражданско-правовому договору, облагаемые взносами на НС и ПЗ'"), Ложь, Истина, Ложь, Истина, 43, , , Истина);
	
КонецПроцедуры

Процедура ДобавитьКоронавирусныеСубсидии() Экспорт

	ОписатьВидДоходаПоСтраховымВзносам("КоронавирусныеСубсидии",	
		НСтр("ru='Суточные сверх норм, субсидии из-за эпидемии коронавирусной инфекции, облагаемые взносами на НС и ПЗ'"), Ложь, Ложь, Ложь, Истина, 44);
	
КонецПроцедуры


Процедура ОписатьВидДоходаПоСтраховымВзносам(ИмяПредопределенныхДанных, Наименование, ВходитВБазуПФР, ВходитВБазуФОМС, ВходитВБазуФСС, ВходитВБазуФСС_НС, ДопУпорядочивание = 0, ОблагаетсяВзносамиЧастично = Ложь, АвторскиеВознаграждения = Ложь, ВходитВБазу2023 = Ложь, ДоходыПрокуроровСледователей = Ложь)

	СсылкаПредопределенного = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыДоходовПоСтраховымВзносам." + ИмяПредопределенныхДанных);
	Если ЗначениеЗаполнено(СсылкаПредопределенного) Тогда
		Объект = СсылкаПредопределенного.ПолучитьОбъект();
	Иначе
		Объект = Справочники.ВидыДоходовПоСтраховымВзносам.СоздатьЭлемент();
		Объект.ИмяПредопределенныхДанных = ИмяПредопределенныхДанных;
	КонецЕсли;
	
	Если Объект.Наименование <> Наименование Тогда
		Объект.Наименование = Наименование;
	КонецЕсли;
	
	Если Объект.ВходитВБазуПФР <> ВходитВБазуПФР Тогда
		Объект.ВходитВБазуПФР = ВходитВБазуПФР
	КонецЕсли;
	Если Объект.ВходитВБазуФОМС <> ВходитВБазуФОМС Тогда
		Объект.ВходитВБазуФОМС = ВходитВБазуФОМС
	КонецЕсли;
	Если Объект.ВходитВБазуФСС <> ВходитВБазуФСС Тогда
		Объект.ВходитВБазуФСС = ВходитВБазуФСС
	КонецЕсли;
	Если Объект.ВходитВБазуФСС_НС <> ВходитВБазуФСС_НС Тогда
		Объект.ВходитВБазуФСС_НС = ВходитВБазуФСС_НС
	КонецЕсли;
	Если Объект.ВходитВБазу2023 <> ВходитВБазу2023 Тогда
		Объект.ВходитВБазу2023 = ВходитВБазу2023
	КонецЕсли;
	Если Объект.ОблагаетсяВзносамиЧастично <> ОблагаетсяВзносамиЧастично Тогда
		Объект.ОблагаетсяВзносамиЧастично = ОблагаетсяВзносамиЧастично
	КонецЕсли;
	Если Объект.АвторскиеВознаграждения <> АвторскиеВознаграждения Тогда
		Объект.АвторскиеВознаграждения = АвторскиеВознаграждения
	КонецЕсли;
	Если Объект.ДоходыПрокуроровСледователей <> ДоходыПрокуроровСледователей Тогда
		Объект.ДоходыПрокуроровСледователей = ДоходыПрокуроровСледователей
	КонецЕсли;
	Если ЗначениеЗаполнено(ДопУпорядочивание) И Не ЗначениеЗаполнено(Объект.РеквизитДопУпорядочивания) Тогда
		Объект.РеквизитДопУпорядочивания = ДопУпорядочивание
	КонецЕсли;

	Если Объект.Модифицированность() Тогда
		
		Объект.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
		Объект.ОбменДанными.Загрузка = Истина;
		Объект.Записать();
		
	КонецЕсли;

КонецПроцедуры

Функция НеДоступныеЭлементыПоЗначениямФункциональныхОпций() Экспорт
	
	НеДоступныеЗначения = Новый Массив;
	
	ИмяОпции = "ИспользоватьРасчетДенежногоСодержанияПрокуроров";
	ФункциональнаяОпцияИспользуется = (Метаданные.ФункциональныеОпции.Найти(ИмяОпции) <> Неопределено) И ПолучитьФункциональнуюОпцию(ИмяОпции);
	ИмяОпции = "ИспользоватьРасчетДенежногоСодержанияСудей";
	ФункциональнаяОпцияИспользуется = ФункциональнаяОпцияИспользуется Или (Метаданные.ФункциональныеОпции.Найти(ИмяОпции) <> Неопределено) И ПолучитьФункциональнуюОпцию(ИмяОпции);
		
	Если Не ФункциональнаяОпцияИспользуется Тогда
		
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.КомпенсацииОблагаемыеВзносамиПрокуроров);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ДенежноеСодержаниеПрокуроров);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ДенежноеСодержаниеПрокуроровНеОблагаемыеФСС_НС);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.НеОблагаетсяЦеликомПрокуроров);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.МатпомощьПрокуроров);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.МатпомощьПриРожденииРебенкаПрокуроров);
		
	КонецЕсли; 
	
	ИмяОпции = "ИспользуетсяТрудСтудентовСтуденческихОтрядов";
	ФункциональнаяОпцияИспользуется =
		(Метаданные.ФункциональныеОпции.Найти(ИмяОпции) <> Неопределено);
		
	Если Не ФункциональнаяОпцияИспользуется
		Или Не ПолучитьФункциональнуюОпцию(ИмяОпции) Тогда
		
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ДоходыСтудентовЗаРаботуВСтудотрядеПоГражданскоПравовомуДоговору);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ДоходыСтудентовЗаРаботуВСтудотрядеПоДоговоруГПХОблагаемыеФСС_НС);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ДоходыСтудентовЗаРаботуВСтудотрядеПоТрудовомуДоговору);
		
	КонецЕсли; 
	
	ИмяОпции = "ИспользоватьВоеннуюСлужбу";
	ФункциональнаяОпцияИспользуется =
		(Метаданные.ФункциональныеОпции.Найти(ИмяОпции) <> Неопределено);
		
	Если Не ФункциональнаяОпцияИспользуется
		Или Не ПолучитьФункциональнуюОпцию(ИмяОпции) Тогда
		
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ДенежноеДовольствиеВоеннослужащих);
		
	КонецЕсли; 
	
	ИмяОпции = "ИспользоватьВыплатыПоДоговорамОпеки";
	ФункциональнаяОпцияИспользуется =
		(Метаданные.ФункциональныеОпции.Найти(ИмяОпции) <> Неопределено);
		
	Если Не ФункциональнаяОпцияИспользуется
		Или Не ПолучитьФункциональнуюОпцию(ИмяОпции) Тогда
		
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ВыплатыПоДоговорамОпекиПолучающимСтраховыеПенсии);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ВыплатыПоДоговорамОпекиПолучающимСтраховыеПенсииОблагаемыеФСС_НС);
		
	КонецЕсли; 
	
	Возврат НеДоступныеЗначения;
	
КонецФункции

#КонецОбласти

#КонецЕсли
