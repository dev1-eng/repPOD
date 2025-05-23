
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтруктураЭД = "";
	НаправлениеЭД = "";
	Если Параметры.Свойство("СтруктураЭД", СтруктураЭД) И ТипЗнч(СтруктураЭД) = Тип("Структура")
		И СтруктураЭД.Свойство("НаправлениеЭД", НаправлениеЭД) Тогда
		
		АдресСтруктурыЭД = ПоместитьВоВременноеХранилище(Параметры.СтруктураЭД, УникальныйИдентификатор);
		ЗагрузкаЭД = (НаправлениеЭД = Перечисления.НаправленияЭД.Входящий);
		
		СтруктураЭД.Свойство("ВладелецЭД", ДокументИБ);
		Если ЗагрузкаЭД Тогда
			СсылкаНаЗаполняемыйДокумент = "";
			Если СтруктураЭД.Свойство("СсылкаНаДокумент", СсылкаНаЗаполняемыйДокумент)
				И ЗначениеЗаполнено(СсылкаНаЗаполняемыйДокумент) Тогда
				СпособЗагрузкиДокумента = 1;
			КонецЕсли;
		КонецЕсли;
		ОбменСКонтрагентамиВнутренний.ВыполнитьПросмотрЭДСервер(СтруктураЭД, ЭтотОбъект, УникальныйИдентификатор, ТабличныйДокументФормы, Отказ);
		Для каждого ЭлементКоллекции Из СписокТипов Цикл
			НоваяСтрокаВыбора = Элементы.ТипОбъекта.СписокВыбора.Добавить();
			НоваяСтрокаВыбора.Значение = ЭлементКоллекции.Представление;
		КонецЦикла;
	КонецЕсли;
	
	ЭлектронныйДокумент = Неопределено;
	Если Параметры.Свойство("ЭлектронныйДокумент", ЭлектронныйДокумент) Тогда
		ЗагрузкаЭД = Ложь;
		Параметры.Свойство("ВладелецЭД", ДокументИБ);
		ДанныеЭД = ФайлДанныхЭД(ЭлектронныйДокумент);
		Если ДанныеЭД = Неопределено Тогда
			Возврат;
		КонецЕсли;
		Если ТипЗнч(ДанныеЭД) = Тип("ТабличныйДокумент") Тогда
			ТабличныйДокументФормы = ДанныеЭД;
		КонецЕсли;
	КонецЕсли;
	
	ИзменитьВидимостьДоступностьПриСозданииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
 	ИзменитьВидимостьДоступность();
	
	Если ЭтоАдресВременногоХранилища(АдресСтруктурыРазбораЭД) И ЗначениеЗаполнено(РасширениеФайла) Тогда
		#Если ВебКлиент Тогда
			ПутьКФайлуПросмотра = АдресСтруктурыРазбораЭД;
		#Иначе
			ПутьКФайлуПросмотра = ПолучитьИмяВременногоФайла(РасширениеФайла);
			ДДФайла = ПолучитьИзВременногоХранилища(АдресСтруктурыРазбораЭД);
			ДДФайла.Записать(ПутьКФайлуПросмотра);
		#КонецЕсли
		Если СтрНайти("HTML PDF DOCX XLSX", ВРег(РасширениеФайла)) > 0 Тогда
			
			СформироватьТекстСлужебногоСообщения();
			
			Элементы.Панель.ТекущаяСтраница = Элементы.ПросмотрЭД;
			
		Иначе
			#Если НЕ ВебКлиент Тогда
				ФайловаяСистемаКлиент.ОткрытьФайл(ПутьКФайлуПросмотра);
			#КонецЕсли
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Элементы.КомандаОтображатьДополнительнуюИнформацию.Пометка = Не ОтключитьВыводДопДанных;
	Элементы.КомандаОтображатьОбластьКопияВерна.Пометка = Не ОтключитьВыводКопияВерна;
	
	Если ОтключитьВыводДопДанных ИЛИ ОтключитьВыводКопияВерна Тогда
		ПерезаполнитьТабличныйДокумент();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособЗагрузкиДокументаПриИзменении(Элемент)
	
	ИзменитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура СпособЗагрузкиСправочникаПриИзменении(Элемент)
	
	ИзменитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипОбъектаПриИзменении(Элемент)
	
	ОбработатьВыборТипаОбъекта();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокТиповСправочниковПриИзменении(Элемент)
	
	ОбработатьВыборТипаОбъекта();
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументИБНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ДокументИБ = Неопределено Тогда
		ТекЭлемент = Неопределено;
		Если ЗначениеЗаполнено(ТипОбъекта) Тогда
			Для Каждого ЭлементСписка Из СписокТипов Цикл
				Если ТипОбъекта = ЭлементСписка.Представление Тогда
					ДокументИБ = ЭлементСписка.Значение;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьДействие(Команда)
	
	Если ВидЭД <> Неопределено И ЗагрузкаЭД Тогда
		ПрочитатьНоменклатуруКонтрагентаИзФайла();
	КонецЕсли;
	
	Если ЗагрузкаЭД И ЗначениеЗаполнено(ИмяОбъектаМетаданных) Тогда
		
		ОчиститьСообщения();
		Если ВРег(ВидЭД) = ВРег("РеквизитыОрганизации") Тогда
			ЗагрузитьРеквизитыОрганизации();
		Иначе
			ЗагрузитьДокументЭДО();
		КонецЕсли;
		
	ИначеЕсли ВидЭД = ПредопределенноеЗначение("Перечисление.ВидыЭД.КаталогТоваров") Тогда
		
		Если МожноЗагрузитьЭДВида(ВидЭД) Тогда
			ЗагрузитьКаталогТоваров();
		Иначе
			СообщитьНевозможноЗагрузитьВидЭД(ВидЭД);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДействиеЗавершение(СсылкаНаОбъект = Неопределено, Отказ = Ложь)
	
	Если ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
		ОповеститьОбИзменении(СсылкаНаОбъект);
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		ЭтотОбъект.Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьДополнительнуюИнформацию(Команда)
	
	ОтключитьВыводДопДанных = Не ОтключитьВыводДопДанных;
	ПерезаполнитьТабличныйДокумент();
	ОбновитьОтображениеДанных();
	Элементы.КомандаОтображатьДополнительнуюИнформацию.Пометка = Не ОтключитьВыводДопДанных;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьОбластьКопияВерна(Команда)
	
	ОтключитьВыводКопияВерна = Не ОтключитьВыводКопияВерна;
	ПерезаполнитьТабличныйДокумент();
	ОбновитьОтображениеДанных();
	Элементы.КомандаОтображатьОбластьКопияВерна.Пометка = Не ОтключитьВыводКопияВерна;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПерезаполнитьТабличныйДокумент()

	Если ЗначениеЗаполнено(АдресСтруктурыЭД) Тогда
		СтруктураЭД = ПолучитьИзВременногоХранилища(АдресСтруктурыЭД);
		ОбменСКонтрагентамиВнутренний.ВыполнитьПросмотрЭДСервер(СтруктураЭД, ЭтотОбъект, УникальныйИдентификатор,
			ТабличныйДокументФормы, Ложь);
	Иначе
		ТабличныйДокументФормы = ФайлДанныхЭД(ЭлектронныйДокумент);
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция СоздатьОбъектыИБ(АдресВременногоХранилища, ОшибкаЗаписи)
	
	Перем ДеревоРазбора;
	
	СтруктураРазбора = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	
	Если СтруктураРазбора <> Неопределено И СтруктураРазбора.Свойство("ДеревоРазбора", ДеревоРазбора) Тогда
		// Заполним ссылки на объекты из дерева соответствий, если ссылок нет, тогда будем создавать объекты.
		ОбменСКонтрагентамиВнутренний.ЗаполнитьСсылкиНаОбъектыВДереве(ДеревоРазбора, ОшибкаЗаписи);
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция СохранитьДанныеОбъектаВБД(АдресВременногоХранилища)
	
	СтруктураРазбора = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	
	Если СтруктураРазбора <> Неопределено И СтруктураРазбора.Свойство("ДеревоРазбора") Тогда
		ОбменСКонтрагентамиПереопределяемый.СохранитьДанныеОбъектаВБД(
										СтруктураРазбора.СтрокаОбъекта,
										СтруктураРазбора.ДеревоРазбора);
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура СопоставитьНоменклатуру(ОбработчикОповещения)
	
	Если ЗначениеЗаполнено(СписокНеСопоставленнойНоменклатуры) Тогда
		Настройки = Новый Структура("РежимОткрытияОкна", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		ОбменСКонтрагентамиСлужебныйКлиент.ОткрытьСопоставлениеНоменклатуры(
			СписокНеСопоставленнойНоменклатуры.ВыгрузитьЗначения(), Настройки, ОбработчикОповещения);
	Иначе
		ЗагрузитьДокументВИБ();
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидимостьДоступность()
	
	Если ВРег(ВидЭД) = ВРег("РеквизитыОрганизации") Тогда
		
		Элементы.ЭлементСправочникаИБ.Доступность = (СпособЗагрузкиДокумента = 1);
		
	Иначе	
		Если ЗагрузкаЭД Тогда
			Элементы.ДокументИБ.Доступность = (СпособЗагрузкиДокумента = 1);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьВидимостьДоступностьПриСозданииНаСервере()
	
	Если ЗагрузкаЭД Тогда
		
		Элементы.ГруппаКнопок.Видимость = Истина;
		Элементы.ГруппаГиперссылка.Видимость = Ложь;

		Если ВРег(ВидЭД) = ВРег("РеквизитыОрганизации") Тогда
			
			Заголовок = НСтр("ru = 'Загрузка данных из файла'");
			
			Элементы.ГруппаНастроекСправочники.Видимость = Истина;
			Элементы.ГруппаНастроекДокументы.Видимость = Ложь;
		Иначе
			
			Заголовок = НСтр("ru = 'Загрузка документа из файла'");
			
			Элементы.ГруппаНастроекСправочники.Видимость = Ложь;
			Элементы.ГруппаНастроекДокументы.Видимость = Истина;
		КонецЕсли;
		
	Иначе
		Текст = НСтр("ru = 'Электронный документ'");
		Заголовок = Текст;
		Элементы.ГруппаНастроекСправочники.Видимость = Ложь;
		Элементы.ГруппаНастроекДокументы.Видимость = Ложь;
		Элементы.ГруппаКнопок.Видимость = Ложь;
		Элементы.ГруппаГиперссылка.Видимость = Истина;
	КонецЕсли;
	
	Если ВидЭД = Перечисления.ВидыЭД.КаталогТоваров Тогда
		Элементы.ДокументИБ.Видимость = Ложь;
		Элементы.ТипОбъекта.Заголовок = НСтр("ru = 'Загрузить'");
		ТипОбъекта = НСтр("ru = 'Каталог товаров'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьДокументИБ(ДокументСсылка, ТекстСообщения, Записывать = Ложь,
	ОбновитьСтруктуруРазбора = Ложь, Отказ = Ложь)
	
	ПараметрыФормирования = Новый Структура;
	ПараметрыФормирования.Вставить("АдресСтруктурыРазбораЭД",  АдресСтруктурыРазбораЭД);
	ПараметрыФормирования.Вставить("ВидЭД",                    ВидЭД);
	ПараметрыФормирования.Вставить("ДанныеФайлаРазбора",       ДанныеФайлаРазбора);
	ПараметрыФормирования.Вставить("ДанныеФайлаДопДанных",     ДанныеФайлаДопДанных);
	ПараметрыФормирования.Вставить("ДокументИБ",               ДокументИБ);
	ПараметрыФормирования.Вставить("ИмяОбъектаМетаданных",     ИмяОбъектаМетаданных);
	ПараметрыФормирования.Вставить("Контрагент",               Контрагент);
	ПараметрыФормирования.Вставить("ТипОбъекта",               ТипОбъекта);
	ПараметрыФормирования.Вставить("СпособЗагрузкиДокумента",  СпособЗагрузкиДокумента);
	
	ОбменСКонтрагентамиВнутренний.СформироватьДокументИБ(ПараметрыФормирования, ДокументСсылка, 
		ТекстСообщения, Записывать,	ОбновитьСтруктуруРазбора, Отказ);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция МожноЗагрузитьЭДВида(Знач ВидЭД)
	
	МожноЗагрузить = Истина;
	Если Не ОбменСКонтрагентамиСлужебный.ВидЭДИспользуетсяПоНаправлению(ВидЭД, Перечисления.НаправленияЭД.Входящий) Тогда
		МожноЗагрузить = Ложь;
	КонецЕсли;
	
	Возврат МожноЗагрузить;
	
КонецФункции

&НаСервере
Функция ФайлДанныхЭД(СсылкаНаЭД, Знач ИмяФайлаПодчиненногоЭД = Неопределено)
	
	ПараметрыПросмотра = Новый Структура;
	ПараметрыПросмотра.Вставить("ИмяФайлаПодчиненногоЭД", ИмяФайлаПодчиненногоЭД);
	ПараметрыПросмотра.Вставить("СкрыватьКопияВерна", ОтключитьВыводКопияВерна);
	ПараметрыПросмотра.Вставить("СкрыватьДопДанные", ОтключитьВыводДопДанных);
	ТабличныйДокумент = ОбменСКонтрагентамиВнутренний.ФайлДанныхЭД(СсылкаНаЭД, ПараметрыПросмотра);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьВыборТипаОбъекта()
	
	Если ЗначениеЗаполнено(ТипОбъекта) Тогда
		Для Каждого Элемент Из СписокТипов Цикл
			Если Элемент.Представление = ТипОбъекта Тогда
				ВыбраннаяСсылка = Элемент.Значение;
				Если НЕ ЗначениеЗаполнено(ДокументИБ) ИЛИ ТипЗнч(ДокументИБ) <> ТипЗнч(ВыбраннаяСсылка) Тогда
					ДокументИБ = ВыбраннаяСсылка;
				КонецЕсли;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СформироватьТекстСлужебногоСообщения()
	
	Если ЗначениеЗаполнено(ИмяФайлаXML) Тогда
		
		ЗаголовокЭлемента = НСтр("ru = 'Не удалось прочитать файл """+ ИмяФайлаXML+".""'");
		
	Иначе
		
		ЗаголовокЭлемента = НСтр("ru = 'Не найден файл электронного документа ""* .xml.""'");
		
	КонецЕсли;
	
	Элементы.КомментарийСлужебноеСообщение.Заголовок = ЗаголовокЭлемента;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРеквизитыОрганизации()
	
	Отказ = Ложь;
	ТекстСообщения = "";
	
	Если СпособЗагрузкиДокумента = 1 И Не ЗначениеЗаполнено(ДокументИБ) Тогда
		ТекстСообщения = НСтр("ru = 'Не указан элемент справочника для перезаполнения.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЕсли;
	
	СоздатьОбъектыИБ(АдресСтруктурыРазбораЭД, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
		
	ДанныеФормы = Неопределено;
	СформироватьДокументИБ(ДанныеФормы, ТекстСообщения, Истина,, Отказ);
	Если Отказ Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Ключ", ДанныеФормы);
	РежимОткрытия = РежимОткрытияОкнаФормы.Независимый;
	
	Оповестить("ЗагрузкаРеквизитовКонтрагентаИзФайла", ДанныеФормы);
		
	ФормаЭлемента = ОткрытьФорму(ИмяОбъектаМетаданных +".Форма.ФормаЭлемента",
		ПараметрыФормы,,,,,,РежимОткрытияОкнаФормы.Независимый);
	
	ВыполнитьДействиеЗавершение(ДанныеФормы, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКаталогТоваров()
	
	Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
		ТекстСообщения = НСтр("ru = 'Не указан контрагент.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Контрагент");
		Возврат;
	КонецЕсли;
	
	СоздатьОбъектыИБ(АдресСтруктурыРазбораЭД, Ложь);
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ЗагрузитьКаталогОповещение", ЭтотОбъект) ;
	
	СопоставитьНоменклатуру(ОбработчикОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКаталогОповещение(Результат, ДополнительныеПараметры) Экспорт
	
	СохранитьДанныеОбъектаВБД(АдресСтруктурыРазбораЭД);
	
	ВыполнитьДействиеЗавершение();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДокументЭДО()
	
	Отказ = Ложь;
	ТекстСообщения = "";
	
	Если НЕ МожноЗагрузитьЭДВида(ВидЭД) Тогда
		СообщитьНевозможноЗагрузитьВидЭД(ВидЭД);
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
		ТекстСообщения = НСтр("ru = 'Не указан контрагент.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЕсли;
	
	Если СпособЗагрузкиДокумента = 1 Тогда
		
		Если Не ЗначениеЗаполнено(ДокументИБ) Тогда
			ТекстСообщения = НСтр("ru = 'Не указан документ для перезаполнения.'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
			Отказ = Истина;
		Иначе
			Если ДокументПроведен() Тогда
				Шаблон = НСтр("ru = 'Обработка документа %1.
							|Операция возможна только для непроведенных документов.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, ДокументИБ);
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	СоздатьОбъектыИБ(АдресСтруктурыРазбораЭД, Отказ);
	
	Если Отказ Тогда
		ЗакрытьФорму = Ложь;
		Возврат;
	КонецЕсли;
	
	ОбработчикОповещенияПередЗаполнением = Новый ОписаниеОповещения(
		"СопоставитьПередЗаполнениемОповещение", ЭтотОбъект);
	СопоставитьНоменклатуру(ОбработчикОповещенияПередЗаполнением);
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
	ЗагрузитьДокументВИБ();
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура СопоставитьПередЗаполнениемОповещение(Результат, ДополнительныеПараметры) Экспорт
	
	ЗагрузитьДокументВИБ();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДокументВИБ(ОбновитьСтруктуруРазбора = Ложь)
	
	Отказ = Ложь;
	ДокументСсылка = Неопределено;
	ТекстСообщения = "";
	
	СформироватьДокументИБ(ДокументСсылка, ТекстСообщения, Истина, ОбновитьСтруктуруРазбора, Отказ);
	Если Отказ Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	Иначе
		
		ТекстОповещения	= НСтр("ru = 'Документ загружен.'");
		ТекстПояснения	= ДокументСсылка;
		ДействиеПриНажатии = ?(ЗначениеЗаполнено(ДокументСсылка), ПолучитьНавигационнуюСсылку(ДокументСсылка), "");
		ПоказатьОповещениеПользователя(ТекстОповещения, ДействиеПриНажатии, ТекстПояснения);
	
		МассивОповещения = Новый Массив;
		МассивОповещения.Добавить(ДокументСсылка);
		Оповестить("ОбновитьДокументИБПослеЗаполнения", МассивОповещения);
		
		Если ЗначениеЗаполнено(ДокументСсылка) Тогда
			ПоказатьЗначение(Неопределено, ДокументСсылка);
		КонецЕсли;
		
	КонецЕсли;
	
	ВыполнитьДействиеЗавершение(ДокументСсылка, Отказ);
	
КонецПроцедуры

&НаСервере
Функция ДокументПроведен()
	
	Проведен = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументИБ, "Проведен");
	Возврат Проведен;
	
КонецФункции

&НаКлиенте
Процедура СообщитьНевозможноЗагрузитьВидЭД(ВидЭД)
	
	ТекстСообщения = НСтр("ru = 'Не поддерживается загрузка электронных документов вида ""%1"".'");
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1", ВидЭД);
	ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНоменклатуруКонтрагентаИзФайла()
	
	СвойстваЭлектронногоДокумента = Новый Структура("ВидЭД, ПрикладнойВидЭД", ПрикладнойВидЭД, ПрикладнойВидЭД);
	Если НЕ ОбменСКонтрагентамиСлужебный.ИспользоватьСопоставлениеНоменклатуры(СвойстваЭлектронногоДокумента) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Контрагент) Тогда
		Возврат;
	КонецЕсли;
	
	ИмяФайлаЭлектронногоДокумента = ПолучитьИмяВременногоФайла("xml");
	ДанныеФайла = ПолучитьИзВременногоХранилища(ДанныеФайлаРазбора);
	ДанныеФайла.Записать(ИмяФайлаЭлектронногоДокумента);
	
	НаборНоменклатурыКонтрагентов = ОбменСКонтрагентамиСлужебный.НоменклатураКонтрагентаВФайле(ИмяФайлаЭлектронногоДокумента, Контрагент);
	
	УдалитьФайлы(ИмяФайлаЭлектронногоДокумента);
	
	СписокНоменклатурыКонтрагентов.ЗагрузитьЗначения(НаборНоменклатурыКонтрагентов);
	
	ВыполнитьКонтрольСопоставленияНоменклатуры();
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКонтрольСопоставленияНоменклатуры()
	
	НеСопоставлено = ОбменСКонтрагентамиСлужебный.ВыполнитьКонтрольСопоставленияНоменклатуры(
		Неопределено, СписокНоменклатурыКонтрагентов.ВыгрузитьЗначения(), Ложь);
	
	СписокНеСопоставленнойНоменклатуры.ЗагрузитьЗначения(НеСопоставлено);
	
КонецПроцедуры

#КонецОбласти
