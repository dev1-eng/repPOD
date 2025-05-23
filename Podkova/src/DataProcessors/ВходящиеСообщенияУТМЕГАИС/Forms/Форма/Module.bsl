#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Неопределено, "ОрганизацияЕГАИС", ОрганизацииЕГАИС, СтруктураБыстрогоОтбора, Ложь);
	
	ИнтеграцияЕГАИС.ОтборПоОрганизацииПриСозданииНаСервере(ЭтотОбъект, "Отбор");
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	НастройкиОрганизацияЕГАИС = ИнтеграцияЕГАИСКлиентСервер.СтруктураПоискаПоляДляЗагрузкиИзНастроек(
		"ОрганизацииЕГАИС",
		Настройки);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Неопределено,
	                                                                       "ОрганизацияЕГАИС",
	                                                                       ОрганизацииЕГАИС,
	                                                                       СтруктураБыстрогоОтбора,
	                                                                       НастройкиОрганизацияЕГАИС, Ложь);
	
	Настройки.Удалить("ОрганизацииЕГАИС");
	
	ИнтеграцияЕГАИС.ОтборПоОрганизацииПриСозданииНаСервере(ЭтотОбъект, "Отбор");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПрочитатьСообщения(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область ОтборПоОрганизацииЕГАИС

&НаКлиенте
Процедура ОтборОрганизацииЕГАИСПриИзменении(Элемент)
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, ОрганизацииЕГАИС, Ложь, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
	ПрочитатьСообщения(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииЕГАИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОткрытьФормуВыбораОрганизацийЕГАИС(
		ЭтотОбъект, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииЕГАИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, Неопределено, Ложь, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
	ПрочитатьСообщения(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацииЕГАИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, ВыбранноеЗначение, Ложь, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
	ПрочитатьСообщения(Неопределено);
	
КонецПроцедуры


&НаКлиенте
Процедура ОтборОрганизацияЕГАИСПриИзменении(Элемент)
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, ОрганизацияЕГАИС, Ложь, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
	ПрочитатьСообщения(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияЕГАИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОткрытьФормуВыбораОрганизацийЕГАИС(
		ЭтотОбъект, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияЕГАИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, Неопределено, Ложь, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
	ПрочитатьСообщения(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияЕГАИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(
		ЭтотОбъект, ВыбранноеЗначение, Ложь, "Отбор",
		ИнтеграцияЕГАИСКлиент.ОтборОрганизацияЕГАИСПрефиксы());
	
	ПрочитатьСообщения(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПрочитатьСообщения(Команда)
	
	Объект.ВходящиеСообщения.Очистить();
	
	НачатьПолучениеСпискаВходящихДокументов(
		ИнтеграцияЕГАИСКлиент.ОрганизацииЕГАИСДляОбмена(
			ЭтотОбъект),);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСообщение(Команда)
	
	ДокументыКУдалению = Новый Массив;
	ВыделенныеСтроки = Элементы.ВходящиеСообщения.ВыделенныеСтроки;
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		
		СтрокаТЧ = Объект.ВходящиеСообщения.НайтиПоИдентификатору(ВыделеннаяСтрока);
		
		ДокументКУдалению = Новый Структура;
		ДокументКУдалению.Вставить("ОрганизацияЕГАИС", СтрокаТЧ.ОрганизацияЕГАИС);
		ДокументКУдалению.Вставить("АдресЗапроса",     СтрокаТЧ.АдресЗапроса);
		
		ДокументыКУдалению.Добавить(ДокументКУдалению);
		
	КонецЦикла;
	
	ДанныеДляВыполненияОбменаНаКлиенте = ИнтеграцияЕГАИСВызовСервера.УдалитьВходящиеДокументы(ДокументыКУдалению);
	
	Контекст = Новый Структура;
	Контекст.Вставить("ОповещениеПриЗавершении", ИнтеграцияЕГАИСКлиент.ОповещениеПослеЗавершенииОбмена(Неопределено, Неопределено, Неопределено, ЭтотОбъект.УникальныйИдентификатор));
	Контекст.Вставить("НастройкиОбменаЕГАИС",    ДанныеДляВыполненияОбменаНаКлиенте.НастройкиОбменаЕГАИС);
	Контекст.Вставить("ИдентификаторВладельца",  ЭтотОбъект.УникальныйИдентификатор);
	Контекст.Вставить("ВОсновнойФорме",          Ложь);
	
	ПодтвердитьЗагруженныеСообщения(
		ДанныеДляВыполненияОбменаНаКлиенте.ДокументыКУдалению,
		Контекст);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗагрузкаДокументов

&НаКлиенте
Процедура НачатьПолучениеСпискаВходящихДокументов(ОрганизацииЕГАИС = Неопределено, ОповещениеПриЗавершении = Неопределено)
	
	ОчиститьСообщения();
	
	ДанныеДляВыполненияОбменаНаКлиенте = ИнтеграцияЕГАИСВызовСервера.ВходящиеСообщения(ОрганизацииЕГАИС);
	
	Контекст = Новый Структура;
	Контекст.Вставить("ОповещениеПриЗавершении", ИнтеграцияЕГАИСКлиент.ОповещениеПослеЗавершенииОбмена(Неопределено, Неопределено, ОповещениеПриЗавершении, ЭтотОбъект.УникальныйИдентификатор));
	Контекст.Вставить("НастройкиОбменаЕГАИС",    ДанныеДляВыполненияОбменаНаКлиенте.НастройкиОбменаЕГАИС);
	Контекст.Вставить("ИдентификаторВладельца",  ЭтотОбъект.УникальныйИдентификатор);
	Контекст.Вставить("ВОсновнойФорме",          Ложь);
	
	ПараметрыОбработкиСпискаВходящихДокументов = ИнтеграцияЕГАИССлужебныйКлиент.ОбщиеПараметрыОбменаНаКлиенте(Контекст);
	ПараметрыОбработкиСпискаВходящихДокументов.Вставить("ДокументыКЗагрузке", ДанныеДляВыполненияОбменаНаКлиенте.ДокументыКЗагрузке);
	
	ОповещениеПриЗавершенииПолученияСпискаВходящихДокументов = Новый ОписаниеОповещения(
		"ОбработатьСписокВходящихДокументов",
		ЭтотОбъект,
		ПараметрыОбработкиСпискаВходящихДокументов);
	
	ДополнительныеПараметры = ИнтеграцияЕГАИССлужебныйКлиент.ОбщиеПараметрыОбменаНаКлиенте(Контекст);
	ДополнительныеПараметры.ОповещениеПриЗавершении = ОповещениеПриЗавершенииПолученияСпискаВходящихДокументов;
	ДополнительныеПараметры.Вставить("Результат",   Новый Соответствие);
	ДополнительныеПараметры.Вставить("ТекстОшибки", "");
	
	ИнтеграцияЕГАИССлужебныйКлиент.ПолучитьСпискиВходящихСообщений(
		ИнтеграцияЕГАИСКлиентСервер.ОрганизацииЕГАИС(ДанныеДляВыполненияОбменаНаКлиенте.НастройкиОбменаЕГАИС),
		ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьСписокВходящихДокументов(ДанныеОбработкиТекстОшибки, Контекст) Экспорт
	
	ДополнительныеПараметры = ИнтеграцияЕГАИССлужебныйКлиент.ОбщиеПараметрыОбменаНаКлиенте(Контекст);
	ДополнительныеПараметры.Вставить("ДокументыКЗагрузке", Контекст.ДокументыКЗагрузке);
	
	ПолучитьСообщения(ДанныеОбработкиТекстОшибки.ДанныеОбработки, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСообщения(ДанныеДокументовКПолучению, Контекст)
	
	Если ИнтеграцияЕГАИССлужебныйКлиент.ОбменУжеЗапущен(Контекст) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПриложения.Вставить("ЕГАИС.ДанныеСеансаОбмена",
		ИнтеграцияЕГАИССлужебныйКлиент.СохраняемыеДанныеОбмена(
			ДанныеДокументовКПолучению,
			Контекст,
			Новый ОписаниеОповещения("ПолучитьСообщение", ИнтеграцияЕГАИССлужебныйКлиент),
			Новый ОписаниеОповещения("ПослеПолученияСообщений", ЭтотОбъект)));
	ПодключитьОбработчикОжидания("ОбработчикОжиданияОбменаОчереднойПорциейДанныхЕГАИС", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияСообщений(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	ДанныеОбменаЕГАИС = ПараметрыПриложения["ЕГАИС.ДанныеСеансаОбмена"];
	ИнтеграцияЕГАИССлужебныйКлиент.ЗакрытьФормуВыполненияОбмена(ДанныеОбменаЕГАИС.Контекст.Форма);
	Результат = ДанныеОбменаЕГАИС.Результат;
	
	ПараметрыПриложения.Удалить("ЕГАИС.ДанныеСеансаОбмена");
	
	Для Каждого КлючИЗначение Из Результат Цикл
		
		Для Каждого ЭлементДанных Из КлючИЗначение.Значение Цикл
			
			СтрокаТЧ = Объект.ВходящиеСообщения.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТЧ, ЭлементДанных);
			СтрокаТЧ.ОрганизацияЕГАИС = КлючИЗначение.Ключ;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область УдалениеСообщений

&НаКлиенте
Процедура ПодтвердитьЗагруженныеСообщения(ДанныеДокументовКУдалению, Контекст)
	
	Если ИнтеграцияЕГАИССлужебныйКлиент.ОбменУжеЗапущен(Контекст) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПриложения.Вставить("ЕГАИС.ДанныеСеансаОбмена",
		ИнтеграцияЕГАИССлужебныйКлиент.СохраняемыеДанныеОбмена(
			ДанныеДокументовКУдалению,
			Контекст,
			Новый ОписаниеОповещения("ПодтвердитьСообщение", ИнтеграцияЕГАИССлужебныйКлиент),
			Новый ОписаниеОповещения("ПослеПодтвержденияСообщений", ЭтотОбъект)));
	ПодключитьОбработчикОжидания("ОбработчикОжиданияОбменаОчереднойПорциейДанныхЕГАИС", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПодтвержденияСообщений(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	ДанныеОбменаЕГАИС = ПараметрыПриложения["ЕГАИС.ДанныеСеансаОбмена"];
	ИнтеграцияЕГАИССлужебныйКлиент.ЗакрытьФормуВыполненияОбмена(ДанныеОбменаЕГАИС.Контекст.Форма);
	ПараметрыПриложения.Удалить("ЕГАИС.ДанныеСеансаОбмена");
	
	ПрочитатьСообщения(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти