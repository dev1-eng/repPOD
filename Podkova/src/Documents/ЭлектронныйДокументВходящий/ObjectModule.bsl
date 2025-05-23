#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	// Вызывается непосредственно до записи объекта в базу данных
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ЭтоНовый() Тогда
		
		Если ВидЭД = Перечисления.ВидыЭД.ПроизвольныйЭД Тогда
			Если Не ЗначениеЗаполнено(НаименованиеДокументаОтправителя) Тогда
				НаименованиеДокументаОтправителя = ТипДокумента;
			КонецЕсли;
			Если Не ЗначениеЗаполнено(ДатаДокументаОтправителя) Тогда
				ДатаДокументаОтправителя = НачалоДня(Дата);
			КонецЕсли;
			Если Не ЗначениеЗаполнено(НомерДокументаОтправителя) Тогда
				НомерДокументаОтправителя = Номер;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьИсториюОбработки();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ОчиститьИсториюОбработки();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьИсториюОбработки() 
	
	СостоянияПолучен = Новый Массив;
	СостоянияПодписан = Новый Массив;
	СостоянияАннулирован = Новый Массив;
	
	ДатаСеанса = ТекущаяДатаСеанса();
	
	СостоянияПодписан.Добавить(Перечисления.СостоянияВерсийЭД.ОбменЗавершен);
	СостоянияПодписан.Добавить(Перечисления.СостоянияВерсийЭД.ОбменЗавершенСИсправлением);
	СостоянияПодписан.Добавить(Перечисления.СостоянияВерсийЭД.ОжидаетсяОтправка);
	СостоянияПодписан.Добавить(Перечисления.СостоянияВерсийЭД.ОжидаетсяПередачаОператору);
	СостоянияПодписан.Добавить(Перечисления.СостоянияВерсийЭД.ОжидаетсяОтправкаПолучателю);
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СостоянияПолучен, СостоянияПодписан);
	СостоянияПолучен.Добавить(Перечисления.СостоянияВерсийЭД.ЗакрытПринудительно);
	СостоянияПолучен.Добавить(Перечисления.СостоянияВерсийЭД.НаПодписи);
	СостоянияПолучен.Добавить(Перечисления.СостоянияВерсийЭД.НаУтверждении);
	
	СостоянияАннулирован.Добавить(Перечисления.СостоянияВерсийЭД.Аннулирован);
	
	Если Не ЗначениеЗаполнено(ДатаПолучения)
		И СостоянияПолучен.Найти(СостояниеЭДО) <> Неопределено Тогда
		ДатаПолучения = ДатаСеанса;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ДатаПодписания)
		И СостоянияПодписан.Найти(СостояниеЭДО) <> Неопределено Тогда
		ДатаПодписания = ДатаСеанса;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ДатаАннулирования)
		И СостоянияАннулирован.Найти(СостояниеЭДО) <> Неопределено Тогда
		ДатаАннулирования = ДатаСеанса;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьИсториюОбработки()
	
	ДатаПолучения = Дата(1, 1, 1);
	ДатаПодписания = Дата(1, 1, 1);
	ДатаАннулирования = Дата(1, 1, 1);
	
КонецПроцедуры

#КонецОбласти

#Иначе
	
	ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
	
#КонецЕсли