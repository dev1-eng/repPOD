///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ОпределитьПоведениеВМобильномКлиенте();
	
	ПрототипКлюч = Параметры.КлючТекущихНастроек;
	ОтчетИнформация = ВариантыОтчетов.ИнформацияОбОтчете(Параметры.КлючОбъекта, Истина);
	
	Контекст = Новый Структура;
	Контекст.Вставить("ТекущийПользователь", Пользователи.АвторизованныйПользователь());
	Контекст.Вставить("ПолныеПраваНаВарианты", ВариантыОтчетов.ПолныеПраваНаВарианты());
	Контекст.Вставить("ОтчетСсылка", ОтчетИнформация.Отчет);
	Контекст.Вставить("ОтчетИмя", ОтчетИнформация.ОтчетИмя);
	Контекст.Вставить("ТипОтчета", ОтчетИнформация.ТипОтчета);
	Контекст.Вставить("ЭтоВнешний", ОтчетИнформация.ТипОтчета = Перечисления.ТипыОтчетов.Внешний);
	Контекст.Вставить("ПоискПоНаименованию", Новый Соответствие);
	
	ЗаполнитьСписокВариантов();
	
	РегистрыСведений.НастройкиВариантовОтчетов.ПрочитатьНастройкиДоступностиВариантаОтчета(
		ВариантСсылка, ПользователиВарианта, ИспользоватьГруппыПользователей, ИспользоватьВнешнихПользователей);
	
	Элементы.Доступен.ТолькоПросмотр = Не Контекст.ПолныеПраваНаВарианты;
	Если Контекст.ЭтоВнешний Тогда
		
		Элементы.Назад.Видимость = Ложь;
		Элементы.Далее.Видимость = Ложь;
		Элементы.Доступен.Видимость = Ложь;
		Элементы.ДекорацияЧтоБудетДальшеНовый.Заголовок = НСтр("ru = 'Будет сохранен новый вариант отчета.'");
		Элементы.ДекорацияЧтоБудетДальшеПерезапись.Заголовок = НСтр("ru = 'Будет перезаписан существующий вариант отчета.'");
		
	КонецЕсли;
	
	МультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	
	Элементы.Описание.КнопкаВыбора = Не Элементы.Описание.КнопкаОткрытия;
	
	ВариантыОтчетов.ОпределитьПоведениеСпискаПользователейВариантаОтчета(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ТекущийЭлемент = Элементы.Наименование;
	ВариантыОтчетовКлиент.ОформитьПользователейВариантаОтчета(ЭтотОбъект, Ложь);
	
	ЭтоКонтекстныйВариантОтчета = ЗначениеЗаполнено(ВладелецФормы.КонтекстВарианта);
	
	Если ЭтоКонтекстныйВариантОтчета Тогда 
		Элементы.Назад.Видимость = Ложь;
		Элементы.Далее.Видимость = Ложь;
		
		ВариантыКонтекста = ВладелецФормы.ВариантыКонтекста;
		ПодключитьОбработчикОжидания("ЗаполнитьСписокВариантовОтложенно", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ЗначениеЗаполнено(Объект.Наименование) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Поле ""Наименование"" не заполнено'"),
			,
			"Наименование");
		Отказ = Истина;
	ИначеЕсли ВариантыОтчетов.НаименованиеЗанято(Контекст.ОтчетСсылка, ВариантСсылка, Объект.Наименование) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '""%1"" занято, необходимо указать другое Наименование.'"),
				Объект.Наименование),
			,
			"Наименование");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = ИмяФормы Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяСобытия = ВариантыОтчетовКлиент.ИмяСобытияИзменениеВарианта()
		Или ИмяСобытия = "Запись_НаборКонстант" Тогда
		ЗаполнитьСписокВариантов();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	НаименованиеМодифицировано = Истина;
	УстановитьСценарийСохраненияВарианта();
	ВариантыОтчетовКлиент.ОформитьПользователейВариантаОтчета(ЭтотОбъект, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступенПриИзменении(Элемент)
	
	Объект.ТолькоДляАвтора = (Доступен = "ТолькоДляАвтора");
	ВариантыОтчетовКлиент.ОформитьПользователейВариантаОтчета(ЭтотОбъект, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ОписаниеНачалоВыбораЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(
		Оповещение, Элементы.Описание.ТекстРедактирования, НСтр("ru = 'Описание'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеПриИзменении(Элемент)
	
	ОписаниеМодифицировано = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Открытие(Элемент, СтандартнаяОбработка)
	МультиязычностьКлиент.ПриОткрытии(ЭтотОбъект, Объект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПользователиВарианта

&НаКлиенте
Процедура ПользователиВариантаПриИзменении(Элемент)
	
	ВариантыОтчетовКлиент.ОформитьПользователейВариантаОтчета(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиВариантаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиВариантаПередУдалением(Элемент, Отказ)
	
	Если Не ИспользоватьГруппыПользователей
		И Не ИспользоватьВнешнихПользователей Тогда 
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиВариантаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВариантыОтчетовКлиент.ПользователиВариантаОтчетаОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиВариантаПометкаПриИзменении(Элемент)
	
	ВариантыОтчетовКлиент.ОформитьПользователейВариантаОтчета(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПодсистем

&НаКлиенте
Процедура ДеревоПодсистемИспользованиеПриИзменении(Элемент)
	
	ВариантыОтчетовКлиент.ДеревоПодсистемИспользованиеПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодсистемВажностьПриИзменении(Элемент)
	
	ВариантыОтчетовКлиент.ДеревоПодсистемВажностьПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьПользователей(Команда)
	
	ВариантыОтчетовКлиент.ПодобратьПользователейВариантаОтчета(
		ЭтотОбъект, Элементы.ПользователиВариантаГруппаПодобрать.Видимость);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьГруппыВнешнихПользователей(Команда)
	
	ВариантыОтчетовКлиент.ПодобратьПользователейВариантаОтчета(
		ЭтотОбъект, Элементы.ПользователиВариантаГруппаПодобрать.Видимость, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	ПерейтиНаСтраницу1();
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	Пакет = Новый Структура;
	Пакет.Вставить("ПроверитьСтраницу1", Истина);
	Пакет.Вставить("ПерейтиНаСтраницу2", Истина);
	Пакет.Вставить("ЗаполнитьСтраницу2Сервер", Истина);
	Пакет.Вставить("ПроверитьИЗаписатьСервер", Ложь);
	Пакет.Вставить("ЗакрытьПослеЗаписи", Ложь);
	Пакет.Вставить("ТекущийШаг", Неопределено);
	
	ВыполнитьПакет(Неопределено, Пакет);
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	СохранитьИЗакрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура ВыполнитьПакет(Результат, Пакет) Экспорт
	
	Если Не Пакет.Свойство("ВариантЭтоНовый") Тогда
		Пакет.Вставить("ВариантЭтоНовый", Не ЗначениеЗаполнено(ВариантСсылка));
	КонецЕсли;
	
	// Обработка результата предыдущего шага.
	Если Пакет.ТекущийШаг = "ВопросНаПерезапись" Тогда
		Пакет.ТекущийШаг = Неопределено;
		Если Результат = КодВозвратаДиалога.Да Тогда
			Пакет.Вставить("ВопросНаПерезаписьПройден", Истина);
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	// Выполнение следующего шага.
	Если Пакет.ПроверитьСтраницу1 = Истина Тогда
		// Наименование не введено.
		Если Не ЗначениеЗаполнено(Объект.Наименование) Тогда
			ТекстОшибки = НСтр("ru = 'Поле ""Наименование"" не заполнено'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки, , "Объект.Наименование");
			Возврат;
		КонецЕсли;
		
		// Введено наименование существующего варианта отчета.
		Если Не Пакет.ВариантЭтоНовый Тогда
			Найденные = ВариантыОтчета.НайтиСтроки(Новый Структура("Ссылка", ВариантСсылка));
			Вариант = Найденные[0];
			Если Не ПравоЗаписиВарианта(Вариант, Контекст.ПолныеПраваНаВарианты) Тогда
				ТекстОшибки = НСтр("ru = 'Недостаточно прав для изменения варианта ""%1"". Необходимо выбрать другой вариант или изменить Наименование.'");
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, Объект.Наименование);
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки, , "Объект.Наименование");
				Возврат;
			КонецЕсли;
			
			Если Не Пакет.Свойство("ВопросНаПерезаписьПройден") Тогда
				Если Вариант.ПометкаУдаления = Истина Тогда
					ТекстВопроса = НСтр("ru = 'Вариант отчета ""%1"" помечен на удаление.
					|Заменить помеченный на удаление вариант отчета?'");
					КнопкаПоУмолчанию = КодВозвратаДиалога.Нет;
				Иначе
					ТекстВопроса = НСтр("ru = 'Заменить ранее сохраненный вариант отчета ""%1""?'");
					КнопкаПоУмолчанию = КодВозвратаДиалога.Да;
				КонецЕсли;
				ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, Объект.Наименование);
				Пакет.ТекущийШаг = "ВопросНаПерезапись";
				Обработчик = Новый ОписаниеОповещения("ВыполнитьПакет", ЭтотОбъект, Пакет);
				ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КнопкаПоУмолчанию);
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		// Проверка завершена.
		Пакет.ПроверитьСтраницу1 = Ложь;
	КонецЕсли;
	
	Если Пакет.ПерейтиНаСтраницу2 = Истина Тогда
		// Для внешних отчетов выполняются только проверки заполнения, без переключения страницы.
		Если Не Контекст.ЭтоВнешний Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы.Дополнительно;
			Элементы.Назад.Доступность        = Истина;
			Элементы.Далее.Доступность        = Ложь;
		КонецЕсли;
		
		// Переключение выполнено.
		Пакет.ПерейтиНаСтраницу2 = Ложь;
	КонецЕсли;
	
	Если Пакет.ЗаполнитьСтраницу2Сервер = Истина
		Или Пакет.ПроверитьИЗаписатьСервер = Истина Тогда
		
		ВыполнитьПакетСервер(Пакет);
		
		СтрокиДерева = ДеревоПодсистем.ПолучитьЭлементы();
		Для Каждого СтрокаДерева Из СтрокиДерева Цикл
			Элементы.ДеревоПодсистем.Развернуть(СтрокаДерева.ПолучитьИдентификатор(), Истина);
		КонецЦикла;
		
		Если Пакет.Отказ = Истина Тогда
			ПерейтиНаСтраницу1();
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Пакет.ЗакрытьПослеЗаписи = Истина Тогда
		ВариантыОтчетовКлиент.ОбновитьОткрытыеФормы(, ИмяФормы);
		Закрыть(Новый ВыборНастроек(ВариантКлючВарианта));
		Пакет.ЗакрытьПослеЗаписи = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаСтраницу1()
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.Основное;
	Элементы.Назад.Доступность        = Ложь;
	Элементы.Далее.Заголовок          = "";
	Элементы.Далее.Доступность        = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть()
	
	СтраницаДополнительноЗаполнена = (Элементы.Страницы.ТекущаяСтраница = Элементы.Дополнительно);
	
	Пакет = Новый Структура;
	Пакет.Вставить("ПроверитьСтраницу1",       Не СтраницаДополнительноЗаполнена);
	Пакет.Вставить("ПерейтиНаСтраницу2",       Не СтраницаДополнительноЗаполнена);
	Пакет.Вставить("ЗаполнитьСтраницу2Сервер", Не СтраницаДополнительноЗаполнена);
	Пакет.Вставить("ПроверитьИЗаписатьСервер", Истина);
	Пакет.Вставить("ЗакрытьПослеЗаписи",       Истина);
	Пакет.Вставить("ТекущийШаг", Неопределено);
	
	ВыполнитьПакет(Неопределено, Пакет);
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеНачалоВыбораЗавершение(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
	
	Если ВведенныйТекст = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Объект.Описание = ВведенныйТекст;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Клиент и сервер

// Возвращает признак наличия права изменения варианта отчета.
//
// Параметры:
//   Вариант - ДанныеФормыКоллекция:
//     * Ссылка - СправочникСсылка.ВариантыОтчетов
//   ПолныеПраваНаВарианты - Булево
//
// Возвращаемое значение:
//   Булево
//
&НаКлиентеНаСервереБезКонтекста
Функция ПравоНастройкиВарианта(Вариант, ПолныеПраваНаВарианты)
	
	Возврат (ПолныеПраваНаВарианты Или Вариант.АвторТекущийПользователь) И ЗначениеЗаполнено(Вариант.Ссылка);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПравоЗаписиВарианта(Вариант, ПолныеПраваНаВарианты)
	
	Возврат Вариант.Пользовательский И ПравоНастройкиВарианта(Вариант, ПолныеПраваНаВарианты);
	
КонецФункции

// Возвращает уникальное наименование варианта отчета.
// 
// Параметры:
//   Вариант - ДанныеФормыКоллекция:
//     * Ссылка - СправочникСсылка.ВариантыОтчетов
//     * Наименование - Строка
//   ВариантыОтчета - ДанныеФормыКоллекция
//
// Возвращаемое значение:
//   Строка
//
&НаКлиентеНаСервереБезКонтекста
Функция СформироватьСвободноеНаименование(Вариант, ВариантыОтчета)
	
	ШаблонИмениВарианта = СокрЛП(Вариант.Наименование) +" - "+ НСтр("ru = 'копия'");
	
	СвободноеНаименование = ШаблонИмениВарианта;
	Найденные = ВариантыОтчета.НайтиСтроки(Новый Структура("Наименование", СвободноеНаименование));
	Если Найденные.Количество() = 0 Тогда
		Возврат СвободноеНаименование;
	КонецЕсли;
	
	НомерВарианта = 1;
	Пока Истина Цикл
		НомерВарианта = НомерВарианта + 1;
		СвободноеНаименование = ШаблонИмениВарианта +" (" + Формат(НомерВарианта, "") + ")";
		Найденные = ВариантыОтчета.НайтиСтроки(Новый Структура("Наименование", СвободноеНаименование));
		Если Найденные.Количество() = 0 Тогда
			Возврат СвободноеНаименование;
		КонецЕсли;
	КонецЦикла;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьСписокВариантовОтложенно()
	
	Если ВариантыКонтекста.Количество() > 0 Тогда 
		ЗаполнитьСписокВариантов();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Процедура ВыполнитьПакетСервер(Пакет)
	
	Пакет.Вставить("Отказ", Ложь);
	
	Если Пакет.ЗаполнитьСтраницу2Сервер = Истина Тогда
		Если Не Контекст.ЭтоВнешний Тогда
			ПерезаполнитьСтраницуДополнительно(Пакет);
		КонецЕсли;
		Пакет.ЗаполнитьСтраницу2Сервер = Ложь;
	КонецЕсли;
	
	Если Пакет.ПроверитьИЗаписатьСервер = Истина Тогда
		ПроверитьИЗаписатьВариантОтчета(Пакет);
		Пакет.ПроверитьИЗаписатьСервер = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьСтраницуДополнительно(Пакет)
	Если Пакет.ВариантЭтоНовый Тогда
		ВариантОснование = ПрототипСсылка;
	Иначе
		ВариантОснование = ВариантСсылка;
	КонецЕсли;
	
	ДеревоПриемник = ВариантыОтчетов.ДеревоПодсистемСформировать(ЭтотОбъект, ВариантОснование);
	ЗначениеВРеквизитФормы(ДеревоПриемник, "ДеревоПодсистем");
КонецПроцедуры

&НаСервере
Процедура ПроверитьИЗаписатьВариантОтчета(Пакет)
	
	ЭтоНовыйВариантОтчета = Не ЗначениеЗаполнено(ВариантСсылка);
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		Если Не ЭтоНовыйВариантОтчета Тогда
			
			ЭлементБлокировки = Блокировка.Добавить(Метаданные.Справочники.ВариантыОтчетов.ПолноеИмя());
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ВариантСсылка);
			
		КонецЕсли;
		
		Блокировка.Заблокировать();
		
		Если ЭтоНовыйВариантОтчета И ВариантыОтчетов.НаименованиеЗанято(Контекст.ОтчетСсылка, ВариантСсылка, Объект.Наименование) Тогда
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '""%1"" занято, необходимо указать другое наименование.'"), Объект.Наименование);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "Объект.Наименование");
			Пакет.Отказ = Истина;
			ОтменитьТранзакцию();
			
			Возврат;
			
		КонецЕсли;
		
		Если ЭтоНовыйВариантОтчета Тогда
			
			ВариантОбъект = Справочники.ВариантыОтчетов.СоздатьЭлемент();
			ВариантОбъект.Отчет            = Контекст.ОтчетСсылка;
			ВариантОбъект.ТипОтчета        = Контекст.ТипОтчета;
			ВариантОбъект.КлючВарианта     = Строка(Новый УникальныйИдентификатор());
			ВариантОбъект.Пользовательский = Истина;
			ВариантОбъект.Автор            = Контекст.ТекущийПользователь;
			
			Если ПрототипПредопределенный Тогда
				ВариантОбъект.Родитель = ПрототипСсылка;
			ИначеЕсли ТипЗнч(ПрототипСсылка) = Тип("СправочникСсылка.ВариантыОтчетов") И Не ПрототипСсылка.Пустая() Тогда
				ВариантОбъект.Родитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПрототипСсылка, "Родитель");
			Иначе
				ВариантОбъект.ЗаполнитьРодителя();
			КонецЕсли;
			
		Иначе
			
			ВариантОбъект = ВариантСсылка.ПолучитьОбъект();
			
		КонецЕсли;
		
		Если Контекст.ЭтоВнешний Тогда
			
			ВариантОбъект.Размещение.Очистить();
			
		Иначе
			
			ДеревоПриемник = РеквизитФормыВЗначение("ДеревоПодсистем", Тип("ДеревоЗначений"));
			
			Если ЭтоНовыйВариантОтчета Тогда
				ИзмененныеРазделы = ДеревоПриемник.Строки.НайтиСтроки(Новый Структура("Использование", 1), Истина);
			Иначе
				ИзмененныеРазделы = ДеревоПриемник.Строки.НайтиСтроки(Новый Структура("Модифицированность", Истина), Истина);
			КонецЕсли;
			
			ВариантыОтчетов.ДеревоПодсистемЗаписать(ВариантОбъект, ИзмененныеРазделы);
			
		КонецЕсли;
		
		ВариантОбъект.Наименование = Объект.Наименование;
		ВариантОбъект.Описание     = Объект.Описание;
		ВариантОбъект.ТолькоДляАвтора      = Объект.ТолькоДляАвтора;
		
		ВариантОбъект.Представления.Загрузить(Объект.Представления.Выгрузить());
		МультиязычностьСервер.ПередЗаписьюНаСервере(ВариантОбъект);
		
		ВариантОбъект.Записать();
		
		ВариантСсылка       = ВариантОбъект.Ссылка;
		ВариантКлючВарианта = ВариантОбъект.КлючВарианта;
		
		Если СброситьНастройки Тогда
			ВариантыОтчетов.СброситьПользовательскиеНастройки(ВариантОбъект.Ссылка);
		КонецЕсли;
		
		РегистрыСведений.НастройкиВариантовОтчетов.ЗаписатьНастройкиДоступностиВариантаОтчета(
			ВариантСсылка,
			ЭтоНовыйВариантОтчета,
			ПользователиВарианта,
			ИспользоватьГруппыПользователей,
			ИспользоватьВнешнихПользователей);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура ОпределитьПоведениеВМобильномКлиенте()
	
	ЭтоМобильныйКлиент = ОбщегоНазначения.ЭтоМобильныйКлиент();
	Если Не ЭтоМобильныйКлиент Тогда 
		Возврат;
	КонецЕсли;
	
	ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ВариантыОтчетов.УстановитьУсловноеОформлениеСпискаПользователейВариантаОтчета(ЭтотОбъект);
	ВариантыОтчетов.УстановитьУсловноеОформлениеДереваПодсистем(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВариантов()
	
	ТекущийКлючВарианта = ПрототипКлюч;
	
	ОтборОтчеты = Новый Массив;
	ОтборОтчеты.Добавить(Контекст.ОтчетСсылка);
	ПараметрыПоиска = Новый Структура("Отчеты, ТолькоЛичные", ОтборОтчеты, Истина);
	ТаблицаВариантов = ВариантыОтчетов.ТаблицаВариантовОтчетов(ПараметрыПоиска);
	
	ОтчетыСервер.ДобавитьВариантыКонтекста(Контекст.ОтчетСсылка, ТаблицаВариантов, ВариантыКонтекста);
	
	// Заполнить автовычисляемые колонки.
	ВариантыОтчета.Загрузить(ТаблицаВариантов);
	Для Каждого Вариант Из ВариантыОтчета Цикл
		Вариант.АвторТекущийПользователь = (Вариант.Автор = Контекст.ТекущийПользователь);
		
		Если Вариант.КлючВарианта = ПрототипКлюч Тогда
			ПрототипСсылка = Вариант.Ссылка;
			ПрототипПредопределенный = Не Вариант.Пользовательский;
		КонецЕсли;
	КонецЦикла;
	
	Если Контекст.ЭтоВнешний
		И Не ХранилищаНастроек.ХранилищеВариантовОтчетов.ДобавитьВариантыВнешнегоОтчета(
			ВариантыОтчета, Контекст.ОтчетСсылка, Контекст.ОтчетИмя) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьСценарийСохраненияВарианта();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСценарийСохраненияВарианта()
	
	БудетЗаписанНовый = Ложь;
	БудетПерезаписанСуществующий = Ложь;
	ПерезаписьНевозможна = Ложь;
	
	Если НаименованиеМодифицировано Тогда 
		Поиск = Новый Структура("Наименование", Объект.Наименование);
	Иначе
		Поиск = Новый Структура("КлючВарианта", ПрототипКлюч);
	КонецЕсли;
	
	НайденныеВарианты = ВариантыОтчета.НайтиСтроки(Поиск);
	
	Если НайденныеВарианты.Количество() = 0 Тогда
		
		БудетЗаписанНовый = Истина;
		ВариантСсылка = Неопределено;
		
		Если Не ОписаниеМодифицировано Тогда
			Объект.Описание = "";
		КонецЕсли;
		
		Если Не Контекст.ПолныеПраваНаВарианты Тогда
			Объект.ТолькоДляАвтора = Истина;
		КонецЕсли;
		
	Иначе
		
		Вариант = НайденныеВарианты[0]; // ДанныеФормыЭлементКоллекции
		ПравоЗаписиВарианта = ПравоЗаписиВарианта(Вариант, Контекст.ПолныеПраваНаВарианты);
		
		ЗаполнитьПредставления(Вариант.Ссылка);
		
		Если ПравоЗаписиВарианта Тогда
			
			БудетПерезаписанСуществующий = Истина;
			НаименованиеМодифицировано = Ложь;
			Объект.Наименование = Вариант.Наименование;
			
			ВариантСсылка = Вариант.Ссылка;
			Если Контекст.ПолныеПраваНаВарианты Тогда
				Объект.ТолькоДляАвтора = Вариант.ТолькоДляАвтора;
			Иначе
				Объект.ТолькоДляАвтора = Истина;
			КонецЕсли;
			
			Если Не ОписаниеМодифицировано Тогда
				Объект.Описание = Вариант.Описание;
			КонецЕсли;
			
		Иначе
			
			Если НаименованиеМодифицировано Тогда
				ПерезаписьНевозможна = Истина;
			Иначе
				БудетЗаписанНовый = Истина;
				Объект.Наименование = СформироватьСвободноеНаименование(Вариант, ВариантыОтчета);
			КонецЕсли;
			
			ВариантСсылка = Неопределено;
			Объект.ТолькоДляАвтора = Истина;
			
			Если Не ОписаниеМодифицировано Тогда
				Объект.Описание = "";
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НаименованиеМодифицировано Тогда
		Поиск = Новый Структура("КодЯзыка", ТекущийЯзык().КодЯзыка);
		НайденныеПредставления = Объект.Представления.НайтиСтроки(Поиск);
		
		Если НайденныеПредставления.Количество() > 0 Тогда 
			НайденныеПредставления[0].Наименование = Объект.Наименование;
		КонецЕсли;
	КонецЕсли;
	
	Доступен = ?(Объект.ТолькоДляАвтора, "ТолькоДляАвтора", "УказаннымПользователям");
	
	Если БудетЗаписанНовый Тогда
		
		Элементы.ЧтоБудетДальше.ТекущаяСтраница = Элементы.Новый;
		Элементы.СброситьНастройки.Видимость = Ложь;
		Элементы.Далее.Доступность     = Истина;
		Элементы.Сохранить.Доступность = Истина;
		
	ИначеЕсли БудетПерезаписанСуществующий Тогда
		
		Элементы.ЧтоБудетДальше.ТекущаяСтраница = Элементы.Перезапись;
		Элементы.СброситьНастройки.Видимость = Истина;
		Элементы.Далее.Доступность     = Истина;
		Элементы.Сохранить.Доступность = Истина;
		
	ИначеЕсли ПерезаписьНевозможна Тогда
		
		Элементы.ЧтоБудетДальше.ТекущаяСтраница = Элементы.ПерезаписьНевозможна;
		Элементы.СброситьНастройки.Видимость = Ложь;
		Элементы.Далее.Доступность     = Ложь;
		Элементы.Сохранить.Доступность = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПредставления(Вариант)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	&КодОсновногоЯзыка КАК КодЯзыка,
	|	ВЫБОР
	|		КОГДА НЕ ИзКонфигурации.Наименование ЕСТЬ NULL
	|			ТОГДА ИзКонфигурации.Наименование
	|		КОГДА НЕ ИзРасширений.Наименование ЕСТЬ NULL
	|			ТОГДА ИзРасширений.Наименование
	|		ИНАЧЕ Пользовательские.Наименование
	|	КОНЕЦ КАК Наименование,
	|	ВЫБОР
	|		КОГДА ПОДСТРОКА(Пользовательские.Описание, 1, 1) <> """"
	|			ТОГДА Пользовательские.Описание
	|		КОГДА НЕ ИзКонфигурации.Описание ЕСТЬ NULL
	|			ТОГДА ИзКонфигурации.Описание
	|		КОГДА НЕ ИзРасширений.Описание ЕСТЬ NULL
	|			ТОГДА ИзРасширений.Описание
	|		ИНАЧЕ ВЫРАЗИТЬ("""" КАК СТРОКА(1000))
	|	КОНЕЦ КАК Описание
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК Пользовательские
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПредопределенныеВариантыОтчетов КАК ИзКонфигурации
	|		ПО ИзКонфигурации.Ссылка = Пользовательские.ПредопределенныйВариант
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПредопределенныеВариантыОтчетовРасширений КАК ИзРасширений
	|		ПО ИзРасширений.Ссылка = Пользовательские.ПредопределенныйВариант
	|ГДЕ
	|	Пользовательские.Ссылка = &Вариант
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА НЕ ПредставленияИзКонфигурации.КодЯзыка ЕСТЬ NULL
	|			ТОГДА ПредставленияИзКонфигурации.КодЯзыка
	|		КОГДА НЕ ПредставленияИзРасширений.КодЯзыка ЕСТЬ NULL
	|			ТОГДА ПредставленияИзРасширений.КодЯзыка
	|		КОГДА НЕ ПредставленияПользовательских.КодЯзыка ЕСТЬ NULL
	|			ТОГДА ПредставленияПользовательских.КодЯзыка
	|		ИНАЧЕ ВЫРАЗИТЬ("""" КАК СТРОКА(10))
	|	КОНЕЦ КАК КодЯзыка,
	|	ВЫБОР
	|		КОГДА НЕ ПредставленияИзКонфигурации.Наименование ЕСТЬ NULL
	|			ТОГДА ПредставленияИзКонфигурации.Наименование
	|		КОГДА НЕ ПредставленияИзРасширений.Наименование ЕСТЬ NULL
	|			ТОГДА ПредставленияИзРасширений.Наименование
	|		КОГДА НЕ ПредставленияПользовательских.Наименование ЕСТЬ NULL
	|			ТОГДА ПредставленияПользовательских.Наименование
	|		ИНАЧЕ ВЫРАЗИТЬ("""" КАК СТРОКА(150))
	|	КОНЕЦ КАК Наименование,
	|	ВЫБОР
	|		КОГДА ПОДСТРОКА(ЕСТЬNULL(ПредставленияПользовательских.Описание, """"), 1, 1) <> """"
	|			ТОГДА ПредставленияПользовательских.Описание
	|		КОГДА НЕ ПредставленияИзКонфигурации.Описание ЕСТЬ NULL
	|			ТОГДА ПредставленияИзКонфигурации.Описание
	|		КОГДА НЕ ПредставленияИзРасширений.Описание ЕСТЬ NULL
	|			ТОГДА ПредставленияИзРасширений.Описание
	|		ИНАЧЕ ВЫРАЗИТЬ("""" КАК СТРОКА(1000))
	|	КОНЕЦ КАК Описание
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК Пользовательские
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВариантыОтчетов.Представления КАК ПредставленияПользовательских
	|		ПО ПредставленияПользовательских.Ссылка = Пользовательские.Ссылка
	|		И ПредставленияПользовательских.КодЯзыка <> &КодОсновногоЯзыка
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПредопределенныеВариантыОтчетов.Представления КАК ПредставленияИзКонфигурации
	|		ПО ПредставленияИзКонфигурации.Ссылка = Пользовательские.ПредопределенныйВариант
	|		И ПредставленияИзКонфигурации.КодЯзыка <> &КодОсновногоЯзыка
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПредопределенныеВариантыОтчетовРасширений.Представления КАК ПредставленияИзРасширений
	|		ПО ПредставленияИзРасширений.Ссылка = Пользовательские.ПредопределенныйВариант
	|		И ПредставленияИзРасширений.КодЯзыка <> &КодОсновногоЯзыка
	|ГДЕ
	|	Пользовательские.Ссылка = &Вариант");
	
	Запрос.УстановитьПараметр("Вариант", Вариант);
	Запрос.УстановитьПараметр("КодОсновногоЯзыка", ОбщегоНазначения.КодОсновногоЯзыка());
	
	Объект.Представления.Очистить();
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		
		Если ЗначениеЗаполнено(Выборка.КодЯзыка) Тогда 
			ЗаполнитьЗначенияСвойств(Объект.Представления.Добавить(), Выборка);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
