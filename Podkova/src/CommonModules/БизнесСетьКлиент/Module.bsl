////////////////////////////////////////////////////////////////////////////////
// Подсистема "Бизнес-сеть".
// ОбщийМодуль.БизнесСетьКлиент.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обновление информацию о новых документах в сервисе "1С:Бизнес-сеть".
//  См. процедуру БизнесСеть.ПодключитьОповещениеОНовыхДокументахВСервисе.
//
// Параметры:
//  Контекст   - ФормаКлиентскогоПриложения - форма, в контексте которой происходит обновление информации.
//  ИмяСобытия - Строка - имя события при оповещении формы. Необязательный.
//
Процедура ОбновитьИнформациюОНовыхДокументахВСервисе(Знач Контекст, Знач ИмяСобытия = "") Экспорт
	
	ИмяРеквизитаИспользованияПодсистемы = БизнесСетьКлиентСервер.ИмяРеквизитаИспользоватьОбменБизнесСеть();
	
	Если Не Контекст[ИмяРеквизитаИспользованияПодсистемы]
		Или (Не ПустаяСтрока(ИмяСобытия)
		И ИмяСобытия <> "ОбновитьСписокВходящихДокументов1СБизнесСеть") Тогда
		Возврат;
	КонецЕсли;
	
	ИмяРеквизитаОперации      = БизнесСетьКлиентСервер.ИмяРеквизитаОперацииПодбораДокументовИзСервиса();
	ИмяРеквизитаВидаДокумента = БизнесСетьКлиентСервер.ИмяРеквизитаВидаДокументаСервиса();
	
	Если Контекст[ИмяРеквизитаОперации] = Неопределено Тогда
		
		ПараметрыОбновления = Новый Структура;
		ПараметрыОбновления.Вставить("ИдентификаторФормы", Контекст.УникальныйИдентификатор);
		ПараметрыОбновления.Вставить("ВидыДокументов",     Контекст[ИмяРеквизитаВидаДокумента].ВыгрузитьЗначения());
		
		Контекст[ИмяРеквизитаОперации] = БизнесСетьВызовСервера.ОбновитьИнформациюОНовыхДокументахВСервисеАсинхронно(
			ПараметрыОбновления);
		
	КонецЕсли;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Контекст);
	ПараметрыОжидания.ВыводитьПрогрессВыполнения      = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания            = Ложь;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьСообщения               = Ложь;
	
	ПараметрыЗавершения = Новый Структура;
	ПараметрыЗавершения.Вставить("Контекст", Контекст);
	
	ЗавершениеОбновления = Новый ОписаниеОповещения("ОбновитьИнформациюОНовыхДокументахВСервисеЗавершение",
		БизнесСетьСлужебныйКлиент, ПараметрыЗавершения);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(Контекст[ИмяРеквизитаОперации],
		ЗавершениеОбновления, ПараметрыОжидания);
	
	Контекст[ИмяРеквизитаОперации] = Неопределено;
	
КонецПроцедуры

// Обработчик подключаемой команды подбора новых документов из сервиса "1С:Бизнес-сеть".
//  См. процедуру БизнесСеть.ПодключитьОповещениеОНовыхДокументахВСервисе.
//
// Параметры:
//  Контекст - ФормаКлиентскогоПриложения - форма, из которой инициируется подбор.
//
Процедура ПодобратьДокументыИзСервисаБизнесСеть(Знач Контекст) Экспорт
	
	ИмяРеквизитаИспользованияПодсистемы = БизнесСетьКлиентСервер.ИмяРеквизитаИспользоватьОбменБизнесСеть();
	
	Если Не Контекст[ИмяРеквизитаИспользованияПодсистемы] Тогда
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура;
	Отбор.Вставить("ВидДокумента", Контекст[БизнесСетьКлиентСервер.ИмяРеквизитаВидаДокументаСервиса()].ВыгрузитьЗначения());
	
	БизнесСетьСлужебныйКлиент.ОткрытьСписокДокументовОбмена("Входящие", Отбор);
	
КонецПроцедуры

#КонецОбласти
