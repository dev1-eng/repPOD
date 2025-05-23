
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не СервисДоставки.ПравоРаботыССервисомДоставки(Истина) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Идентификатор", Идентификатор);
	Параметры.Свойство("ОрганизацияБизнесСетиСсылка", ОрганизацияБизнесСетиСсылка);
	Параметры.Свойство("ТипГрузоперевозки", ТипГрузоперевозки);
	
	Если НЕ ЗначениеЗаполнено(ТипГрузоперевозки) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не выбран тип грузоперевозки'"));
		Отказ = Истина;
		Возврат;
	ИначеЕсли НЕ СервисДоставки.ТипГрузоперевозкиДоступен(ТипГрузоперевозки) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Выбранный тип грузоперевозки не доступен'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	НастроитьФормуПоТипуГрузоперевозки();
	
	СервисДоставкиСлужебный.ПроверитьОрганизациюБизнесСети(ОрганизацияБизнесСетиСсылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Запуск фонового задания для загрузки доступных форм.
	ФоновоеЗаданиеПолучитьДанныеГрузоперевозчика = ПолучитьДанныеГрузоперевозчикаВФоне();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(ФоновоеЗаданиеПолучитьДанныеГрузоперевозчика) Тогда
		
		ПараметрыОперации = Новый Структура("ИмяПроцедуры, НаименованиеОперации, ВыводитьОкноОжидания");
		ПараметрыОперации.ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДанныеГрузоперевозчика();
		ПараметрыОперации.НаименованиеОперации = НСтр("ru = 'Получение заказов на доставку.'");
		
		ОжидатьЗавершениеВыполненияЗапроса(ПараметрыОперации);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура КарточкаГрузоперевозчикаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка,
	ДополнительныеПараметры)
	
	СтандартнаяОбработка = Ложь;
	
	Если Расшифровка = "АдресСайта" Тогда
		
		ПоказатьСайтГрузоперевозчика();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ВыполнитьЗапрос

&НаКлиенте
Процедура ОжидатьЗавершениеВыполненияЗапроса(ПараметрыОперации)
	
	ВыводитьОкноОжидания = ?(ЗначениеЗаполнено(ПараметрыОперации.ВыводитьОкноОжидания), 
																	ПараметрыОперации.ВыводитьОкноОжидания,
																	Ложь);
	// Установка картинки длительной операции.
	Если Не ВыводитьОкноОжидания Тогда
		
		Если ПараметрыОперации.ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДанныеГрузоперевозчика() Тогда
			
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаОжиданиеЗагрузки;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Инициализация обработчик ожидания завершения.
	ИмяФоновогоЗадания = "ФоновоеЗадание" + ПараметрыОперации.ИмяПроцедуры;
	ФоновоеЗадание = ЭтотОбъект[ИмяФоновогоЗадания];
	ПараметрыОперации.Вставить("ФоновоеЗадание", ФоновоеЗадание);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ТекстСообщения = ПараметрыОперации.НаименованиеОперации;
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания = ВыводитьОкноОжидания;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьСообщения = Истина;
	ПараметрыОжидания.Вставить("ИдентификаторЗадания", ФоновоеЗадание.ИдентификаторЗадания);
	
	ОбработкаЗавершения = Новый ОписаниеОповещения("ВыполнитьЗапросЗавершение",
		ЭтотОбъект, ПараметрыОперации);
		
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ФоновоеЗадание, ОбработкаЗавершения, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗапросЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	// Инициализация.
	Отказ = Ложь;
	ТекстСообщения = "";
	ДанныеОбновлены = Ложь;
	ИмяФоновогоЗадания = "ФоновоеЗадание" + ДополнительныеПараметры.ИмяПроцедуры;
	ФоновоеЗадание = ЭтотОбъект[ИмяФоновогоЗадания];
	
	// Скрыть элементы ожидания на форме
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаОсновная;
	
	// Вывод сообщений из фонового задания.
	СервисДоставкиКлиент.ОбработатьРезультатФоновогоЗадания(Результат, ДополнительныеПараметры, Отказ);
	Если Результат = Неопределено ИЛИ ФоновоеЗадание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Проверка результата поиска.
	Если Не Отказ И Результат.Статус = "Выполнено" Тогда
		Если ЗначениеЗаполнено(Результат.АдресРезультата)
			И ЭтоАдресВременногоХранилища(Результат.АдресРезультата) 
			И ДополнительныеПараметры.ФоновоеЗадание.ИдентификаторЗадания 
			= ЭтотОбъект[ИмяФоновогоЗадания].ИдентификаторЗадания Тогда
			
			Если ДополнительныеПараметры.ИмяПроцедуры 
				= СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДанныеГрузоперевозчика() Тогда
				
				// Загрузка результатов запроса.
				ОперацияВыполнена = Истина;
				ЗагрузитьРезультатПолученияДанныхГрузоперевозчика(Результат.АдресРезультата, ОперацияВыполнена);
				ЭтотОбъект[ИмяФоновогоЗадания] = Неопределено;
				ДанныеОбновлены = Истина;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВыполнитьЗапросВФоне

&НаСервере
Функция ВыполнитьЗапросВФоне(ИнтернетПоддержкаПодключена, ПараметрыОперации)
	
	// Проверка подключения Интернет-поддержки пользователей.
	ИнтернетПоддержкаПодключена 
		= ИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
	Если Не ИнтернетПоддержкаПодключена Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Отказ = Ложь;
	ПараметрыЗапроса = ПараметрыЗапроса(ПараметрыОперации, Отказ);
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИмяФоновогоЗадания = "ФоновоеЗадание" + ПараметрыОперации.ИмяПроцедуры;
	ФоновоеЗадание = ЭтотОбъект[ИмяФоновогоЗадания];
	Если ФоновоеЗадание <> Неопределено Тогда
		ОтменитьВыполнениеЗадания(ФоновоеЗадание.ИдентификаторЗадания);
	КонецЕсли;
	
	Задание = Новый Структура("ИмяПроцедуры, Наименование, ПараметрыПроцедуры");
	Задание.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1.'"),
		ПараметрыОперации.НаименованиеОперации);
	Задание.ИмяПроцедуры = "СервисДоставки." + ПараметрыОперации.ИмяПроцедуры;
	Задание.ПараметрыПроцедуры = ПараметрыЗапроса;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = Задание.Наименование;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(Задание.ИмяПроцедуры,
		Задание.ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(ИдентификаторЗадания)
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
		ИдентификаторЗадания = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеГрузоперевозчикаВФоне()
	
	ПараметрыОперации = Новый Структура("ИмяПроцедуры, НаименованиеОперации, ВыводитьОкноОжидания");
	ПараметрыОперации.ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДанныеГрузоперевозчика();
	ПараметрыОперации.НаименованиеОперации = НСтр("ru = 'Получение данные грузоперевозчика.'");
	
	Возврат ВыполнитьЗапросВФоне(Ложь, ПараметрыОперации);
	
КонецФункции

#КонецОбласти

#Область ПараметрыЗапроса

&НаСервере
Функция ПараметрыЗапроса(ПараметрыОперации, Отказ)
	
	ПараметрыЗапроса = Новый Структура();
	
	ИмяПроцедуры = ПараметрыОперации.ИмяПроцедуры;
	
	Если ИмяПроцедуры = СервисДоставкиКлиентСервер.ИмяПроцедурыПолучитьДанныеГрузоперевозчика() Тогда
		ПараметрыЗапроса = ПараметрыЗапросаПолучитьДанныеГрузоперевозчика(ПараметрыЗапроса, Отказ);
	КонецЕсли;
	
	ПараметрыЗапроса.Вставить("ОрганизацияБизнесСетиСсылка", ОрганизацияБизнесСетиСсылка);
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

&НаСервере
Функция ПараметрыЗапросаПолучитьДанныеГрузоперевозчика(ПараметрыЗапроса, Отказ)
	
	ПараметрыЗапроса = СервисДоставки.НовыйПараметрыЗапросаПолучитьДанныеГрузоперевозчика();
	ПараметрыЗапроса.Вставить("Идентификатор", Идентификатор);
	
	Возврат ПараметрыЗапроса;

КонецФункции

#КонецОбласти

#Область ЗагрузитьРезультаты

&НаСервере
Процедура ЗагрузитьРезультатПолученияДанныхГрузоперевозчика(АдресРезультата, ОперацияВыполнена)
	
	Если ЭтоАдресВременногоХранилища(АдресРезультата) Тогда
		Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
		Если ЗначениеЗаполнено(Результат) 
			И ТипЗнч(Результат) = Тип("Структура") Тогда
			
			Если Результат.Свойство("Данные") Тогда
				ЗаполнитьЗначенияСвойств(ЭтаФорма, Результат.Данные);
				Если Результат.Данные.Свойство("ДанныеПоТарифам") Тогда
					ЗаполнитьДанныеТарифов(Результат.Данные.ДанныеПоТарифам);
				КонецЕсли;
				Если ТипГрузоперевозки = 1 Тогда
					ТексЗаголовка = НСтр("ru='1С:Доставка: %1'");
				Иначе
					ТексЗаголовка = НСтр("ru='1С:Курьер: %1'");
				КонецЕсли;
				Заголовок = СтрШаблон(ТексЗаголовка, Наименование + " (Перевозчик)");
			Иначе
				ОперацияВыполнена = Ложь;
			КонецЕсли;
			
			СформироватьКарточкуГрузоперевозчика();
			
			СервисДоставки.ОбработатьБлокОшибок(Результат, ОперацияВыполнена);
		Иначе
			ОперацияВыполнена = Ложь;
		КонецЕсли;
	Иначе
		ОперацияВыполнена = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура НастроитьФормуПоТипуГрузоперевозки();
	
	Если ТипГрузоперевозки = 1 Тогда
		Заголовок = НСтр("ru = '1C:Доставка: Перевозчик'");
	Иначе
		Заголовок = НСтр("ru = '1C:Курьер: Перевозчик'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьКарточкуГрузоперевозчика()
	
	КарточкаГрузоперевозчика = ТабличныйДокументКарточкаГрузоперевозчика();
	
КонецПроцедуры

&НаСервере
Функция ТабличныйДокументКарточкаГрузоперевозчика()
	
	ТабличныйДокумент = Новый ТабличныйДокумент();
	
	Обработка = РеквизитФормыВЗначение("Объект");
	Макет = Обработка.ПолучитьМакет("Грузоперевозчик");
	
	ОбластьМакетаШапка = Макет.ПолучитьОбласть("Шапка");
	
	ПараметрыОбласти = ОбластьМакетаШапка.Параметры;
	
	ПараметрыОбласти.Наименование = НаименованиеПолное;
	ПараметрыОбласти.ЮридическийАдрес = ЮридическийАдрес;
	ПараметрыОбласти.ФизическийАдрес = ФизическийАдрес;
	ПараметрыОбласти.Телефон = Телефон;
	ПараметрыОбласти.АдресСайта = АдресСайта;
	ПараметрыОбласти.РасшифровкаАдресСайта = "АдресСайта";
	ПараметрыОбласти.Описание = Описание;
	
	ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьСайтГрузоперевозчика()
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(АдресСайта);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеТарифов(ДанныеПоТарифам)
	
	Тарифы.Очистить();
	Для Каждого СтрокаТарифа Из ДанныеПоТарифам Цикл
		НоваяСтрокаТарифа = Тарифы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТарифа, СтрокаТарифа);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
