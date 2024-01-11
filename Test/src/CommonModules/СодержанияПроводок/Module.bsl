
#Область ПрограммныйИнтерфейс

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОтражениеНДСПриобретения() Экспорт
	
	Возврат НСтр("ru='НДС по приобретенным ценностям'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СторнированиеНДСПриобретения() Экспорт
	
	Возврат НСтр("ru = 'Сторнирование НДС по приобретенным ценностям'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОтражениеНДСПродажи() Экспорт
	
	Возврат НСтр("ru='НДС с продажи'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция КурсоваяРазница() Экспорт
	
	Возврат НСтр("ru='Курсовая разница'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОплатаОтБанкаЭквайера() Экспорт
	
	Возврат НСтр("ru='Оплата от банка-эквайера'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция КомиссияБанкаЭквайера() Экспорт
	
	Возврат НСтр("ru='Комиссия банка-эквайера'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОприходованиеЗапасов() Экспорт
	
	Возврат НСтр("ru = 'Оприходование запасов'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОприходованиеДополнительныхРасходов() Экспорт
	
	Возврат НСтр("ru = 'Оприходование доп. расходов'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПрочееОприходованиеЗапасов() Экспорт
	
	Возврат НСтр("ru = 'Прочее оприходование запасов'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОприходованиеЗатрат() Экспорт
	
	Возврат НСтр("ru = 'Оприходование затрат'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОприходованиеЗапасовПринятых() Экспорт
	
	Возврат НСтр("ru = 'Оприходование запасов принятых'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОприходованиеЗапасовПереданных() Экспорт
	
	Возврат НСтр("ru = 'Оприходование запасов переданных'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПриемЗапасов() Экспорт
	
	Возврат НСтр("ru = 'Прием запасов'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОплатаПоставщику() Экспорт
	
	Возврат НСтр("ru = 'Оплата поставщику'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПрочиеРасходы() Экспорт
	
	Возврат НСтр("ru = 'Прочие расходы'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПрочиеДоходы() Экспорт
	
	Возврат НСтр("ru = 'Прочие доходы'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПоступлениеПрочихДоходов() Экспорт
	
	Возврат НСтр("ru = 'Поступление прочих доходов'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция Взаимозачет() Экспорт
	
	Возврат НСтр("ru = 'Взаимозачет'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОтражениеЗатрат() Экспорт
	
	Возврат НСтр("ru = 'Отражение затрат'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ЗачетПредоплаты() Экспорт
	
	Возврат НСтр("ru = 'Зачет предоплаты'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СторнированиеПредоплаты() Экспорт
	
	Возврат НСтр("ru = 'Сторнирование предоплаты'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ВосстановлениеАванса() Экспорт
	
	Возврат НСтр("ru = 'Восстановление аванса'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СторнированиеСебестоимости() Экспорт
	
	Возврат НСтр("ru = 'Сторнирование себестоимости'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СторнированиеВыручки() Экспорт
	
	Возврат НСтр("ru = 'Сторнирование выручки'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СторнированиеПоставки() Экспорт
	
	Возврат НСтр("ru = 'Сторнирование поставки'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СторнированиеАвансаПокупателя() Экспорт
	
	Возврат НСтр("ru = 'Сторнирование аванса покупателя'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция Наценка() Экспорт
	
	Возврат НСтр("ru = 'Наценка'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ТаможеннаяПошлина() Экспорт
	
	Возврат НСтр("ru = 'Таможенная пошлина'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ТаможенныйСбор() Экспорт
	
	Возврат НСтр("ru = 'Таможенный сбор'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ТаможенныйШтраф() Экспорт
	
	Возврат НСтр("ru = 'Таможенный штраф'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ТаможенныйНДС() Экспорт
	
	Возврат НСтр("ru = 'НДС, уплаченный таможенным органам'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОтражениеДоходов() Экспорт
	
	Возврат НСтр("ru='Отражение доходов'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОтражениеРасходов() Экспорт
	
	Возврат НСтр("ru='Отражение расходов'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция Выручка() Экспорт
	
	Возврат НСтр("ru='Выручка от продажи'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция Доставка() Экспорт
	
	Возврат НСтр("ru='Выручка от доставки'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ВозникновениеАвансаПокупателя() Экспорт
	
	Возврат НСтр("ru = 'Возникновение аванса покупателя'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СписаниеЗапасов() Экспорт
	
	Возврат НСтр("ru = 'Списание запасов'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СписаниеЗапасовВРезерв() Экспорт
	
	Возврат НСтр("ru = 'Списание запасов из свободного остатка в резерв'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПоступлениеЗапасовВРезерв() Экспорт
	
	Возврат НСтр("ru = 'Поступление запасов в резерв из свободного остатка'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПродажаЗапасовИзРезерва() Экспорт
	
	Возврат НСтр("ru='Продажа запасов из резерва'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПродажаЗапасовИзСвободногоОстатка() Экспорт
	
	Возврат НСтр("ru='Продажа запасов из свободного остатка'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция НачислениеАмортизации() Экспорт
	
	Возврат НСтр("ru = 'Начисление амортизации'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СписаниеАмортизации() Экспорт
	
	Возврат НСтр("ru = 'Списание амортизации'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОплатаДолга() Экспорт
	
	Возврат НСтр("ru = 'Оплата долга'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОплатаСБП() Экспорт
	
	Возврат НСтр("ru = 'Оплата СБП'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОплатаКредитом() Экспорт
	
	Возврат НСтр("ru = 'Оплата кредитом'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОплатаПлатежнымиКартами() Экспорт
	
	Возврат НСтр("ru = 'Оплата платежными картами'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ВыдачаНаличныхСКарты() Экспорт
	
	Возврат НСтр("ru = 'Выдача наличных с платежной карты'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОтражениеРасходовПоПереработке() Экспорт
	
	Возврат НСтр("ru = 'Отражение расходов по переработке'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ЗадолженностьКомитенту() Экспорт
	
	Возврат НСтр("ru = 'Задолженность комитенту'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СторнированиеДоходов() Экспорт
	
	Возврат НСтр("ru = 'Сторнирование доходов'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СторнированиеКурсовойРазницы() Экспорт
	
	Возврат НСтр("ru = 'Сторнирование курсовой разницы'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СторнированиеРасходов() Экспорт
	
	Возврат НСтр("ru = 'Сторнирование расходов'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОтчетОтКомиссионера() Экспорт
	
	Возврат НСтр("ru = 'Отчет комиссионера'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПередачаЗапасов() Экспорт
	
	Возврат НСтр("ru='Передача запасов'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СебестоимостьПродажи() Экспорт
	
	Возврат НСтр("ru='Себестоимость продажи'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция КомиссионноеВознаграждение() Экспорт
	
	Возврат НСтр("ru='Комиссионное вознаграждение'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СторнированиеКомиссионногоВознаграждения() Экспорт
	
	Возврат НСтр("ru = 'Сторнирование комиссионного вознаграждения'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция НачислениеНДСПродажи() Экспорт
	
	Возврат НСтр("ru = 'Начисление НДС с продаж'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ФинансовыйРезультат() Экспорт
	
	Возврат НСтр("ru = 'Финансовый результат'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ЗакрытиеОстаткаСуммБезКоличества() Экспорт
	
	Возврат НСтр("ru = 'Закрытие остатка суммы без количества'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПродажаВалюты() Экспорт
	
	Возврат НСтр("ru = 'Поступление от продажи валюты'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПокупкаВалюты() Экспорт
	
	Возврат НСтр("ru = 'Покупка валюты'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция РозничнаяВыручка() Экспорт
	
	Возврат НСтр("ru = 'Розничная выручка'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция Себестоимость() Экспорт
	
	Возврат НСтр("ru = 'Себестоимость'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ЛичныеСредства() Экспорт
	
	Возврат НСтр("ru = 'Перевод собственных денежных средств'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОприходованиеДенежныхСредствСоСчета() Экспорт
	
	Возврат НСтр("ru = 'Оприходование денежных средств с произвольного счета'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОприходованиеДенежныхСредствИзКассы() Экспорт
	
	Возврат НСтр("ru = 'Оприходование денежных средств с произвольной кассы'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОприходованиеДенежныхСредствВКассу() Экспорт
	
	Возврат НСтр("ru = 'Оприходование денежных средств в кассу'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПогашениеДолгаПодотчетника() Экспорт
	
	Возврат НСтр("ru = 'Погашение долга подотчетника'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ВозникновениеДолгаПодотчетника() Экспорт
	
	Возврат НСтр("ru='Возникновение долга подотчетника'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПоступлениеПоКредиту() Экспорт
	
	Возврат НСтр("ru='Поступление по кредиту'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ВозвратНалога() Экспорт
	
	Возврат НСтр("ru = 'Возврат налога'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОплатаОтБанка() Экспорт
	
	Возврат НСтр("ru = 'Оплата от банка'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция КомиссияБанка() Экспорт
	
	Возврат НСтр("ru = 'Комиссия банка'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПоступлениеДенежныхСредств() Экспорт
	
	Возврат НСтр("ru = 'Поступление денежных средств'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОплатаОтБанкаПоПродажеВКредит() Экспорт
	
	Возврат НСтр("ru = 'Оплата от банка по продаже в кредит'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция СписаниеДенежныхСредств() Экспорт
	
	Возврат НСтр("ru = 'Списание денежных средств на произвольный счет'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ВыдачаЗаймаСотруднику() Экспорт
	
	Возврат НСтр("ru = 'Выдача займа сотруднику'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПеремещениеВКассуККМ() Экспорт
	
	Возврат НСтр("ru = 'Перемещение денежных средств в кассу ККМ'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПоступлениеВКассуККМ() Экспорт
	
	Возврат НСтр("ru = 'Поступление денежных средств в кассу ККМ'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ОплатаНалога() Экспорт
	
	Возврат НСтр("ru='Оплата налога'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция РасходДенежныхСредств() Экспорт
	
	Возврат НСтр("ru='Расход денежных средств'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПеремещениеДенежныхСредств() Экспорт
	
	Возврат НСтр("ru = 'Перемещение денежных средств'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция ПогашениеОбязательствПередПерсоналом() Экспорт
	
	Возврат НСтр("ru='Погашение обязательств перед персоналом'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция БезналичнаяОплатаИлиРассрочка() Экспорт
	
	Возврат НСтр("ru = 'Безналичная оплата или рассрочка'");
	
КонецФункции

// Функция возвращает строковое представление соответствующего содержания проводки
// 
// Возвращаемое значение:
//  Строка - Содержание проводки
//
Функция РасходДенегИзКассыККМ() Экспорт
	
	Возврат НСтр("ru = 'Расход денежных средств из кассы ККМ'");
	
КонецФункции


#КонецОбласти

