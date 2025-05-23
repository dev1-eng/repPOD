#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("Организация", Организация) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеОрганизации = Новый Структура;
	ЭлектронноеВзаимодействиеПереопределяемый.ЗаполнитьРегистрационныеДанныеОрганизации(Организация, ДанныеОрганизации);
	
	ДанныеОрганизации.Свойство("Наименование", НаименованиеОрганизации);    
	ДанныеОрганизации.Свойство("Регион", МестоИзданияПриказа);
	ДанныеОрганизации.Свойство("Должность", ДолжностьРуководителя);
	ДатаПриказа = ТекущаяДатаСеанса();
	ДатаВступленияВСилу = ТекущаяДатаСеанса();

	ЧастиИмени = Новый Структура;
	ЧастиИмени.Вставить("Фамилия",  ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДанныеОрганизации, "Фамилия", ""));
	ЧастиИмени.Вставить("Имя",      ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДанныеОрганизации, "Имя", ""));
	ЧастиИмени.Вставить("Отчество", ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДанныеОрганизации, "Отчество", ""));
	
	ФИОРуководителя = ФизическиеЛицаКлиентСервер.ФамилияИнициалы(ЧастиИмени);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура Сформировать(Команда)
	
	Если ПараметрыЗаполнены() Тогда
		СформироватьПоложение();
	Иначе
		Оповещение = Новый ОписаниеОповещения("ПослеПринятияРешенияОФормировании", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru='Заполнены не все поля. Продолжить?'"), 
						РежимДиалогаВопрос.ОКОтмена,,,
						НСтр("ru='Проверка заполнения'")); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПринятияРешенияОФормировании(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.ОК Тогда 
		СформироватьПоложение();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура СформироватьПоложение()
	
	ПараметрыЗаполнения = Новый Структура;
	
	ПараметрыЗаполнения.Вставить("НаименованиеОрганизации", НаименованиеОрганизации);
	ПараметрыЗаполнения.Вставить("НомерПриказа", НомерПриказа);
	ПараметрыЗаполнения.Вставить("ДатаПриказа", Формат(ДатаПриказа, "ДЛФ=D"));
	ПараметрыЗаполнения.Вставить("МестоИзданияПриказа", МестоИзданияПриказа);
	ПараметрыЗаполнения.Вставить("ДанныеАдминистратора", ДанныеАдминистратора);
	ПараметрыЗаполнения.Вставить("ДатаВступленияВСилу", Формат(ДатаВступленияВСилу, "ДЛФ=D"));
	ПараметрыЗаполнения.Вставить("ДанныеУполномоченногоЛица", ДанныеУполномоченногоЛица);   
	ПараметрыЗаполнения.Вставить("ДолжностьРуководителя", ДолжностьРуководителя);
	ПараметрыЗаполнения.Вставить("ФИОРуководителя", ФИОРуководителя);
	ПараметрыЗаполнения.Вставить("Организация", Организация);
	
	ПоложениеОбИспользованииПЭП = ОбменСКонтрагентамиСлужебныйВызовСервера.ПолучитьШаблонПоложенияПЭП(ПараметрыЗаполнения);
																						
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("Приказ,ПриложениеКПриказу,Приложение1,Приложение2");
	ОписаниеПечатнойФормы = УправлениеПечатьюКлиент.ОписаниеПечатнойФормы(КоллекцияПечатныхФорм, "Приказ"); 
	ОписаниеПечатнойФормы.ТабличныйДокумент = ПоложениеОбИспользованииПЭП.Получить("Приказ");
	ОписаниеПечатнойФормы.СинонимМакета = НСтр("ru = 'Приказ'");

	ОписаниеПечатнойФормы = УправлениеПечатьюКлиент.ОписаниеПечатнойФормы(КоллекцияПечатныхФорм, "ПриложениеКПриказу"); 
	ОписаниеПечатнойФормы.ТабличныйДокумент = ПоложениеОбИспользованииПЭП.Получить("ПриложениеКПриказу");
	ОписаниеПечатнойФормы.СинонимМакета = НСтр("ru = 'Приложение к приказу'");
	
	ОписаниеПечатнойФормы = УправлениеПечатьюКлиент.ОписаниеПечатнойФормы(КоллекцияПечатныхФорм, "Приложение1"); 
	ОписаниеПечатнойФормы.ТабличныйДокумент = ПоложениеОбИспользованииПЭП.Получить("Приложение1");
	ОписаниеПечатнойФормы.СинонимМакета = НСтр("ru = 'Приложение 1'");
	
	ОписаниеПечатнойФормы = УправлениеПечатьюКлиент.ОписаниеПечатнойФормы(КоллекцияПечатныхФорм, "Приложение2"); 
	ОписаниеПечатнойФормы.ТабличныйДокумент = ПоложениеОбИспользованииПЭП.Получить("Приложение2");
	ОписаниеПечатнойФормы.СинонимМакета = НСтр("ru = 'Приложение 2'");
	
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм);
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыЗаполнены()
	
	ПроверяемыеРеквизиты = Новый Массив;
	
	ПроверяемыеРеквизиты.Добавить("НаименованиеОрганизации");
	ПроверяемыеРеквизиты.Добавить("НомерПриказа");
	ПроверяемыеРеквизиты.Добавить("ДатаПриказа");
	ПроверяемыеРеквизиты.Добавить("МестоИзданияПриказа");
	ПроверяемыеРеквизиты.Добавить("ДанныеАдминистратора");
	ПроверяемыеРеквизиты.Добавить("ДатаВступленияВСилу");
	ПроверяемыеРеквизиты.Добавить("ДанныеУполномоченногоЛица");   
	ПроверяемыеРеквизиты.Добавить("ДолжностьРуководителя");
	ПроверяемыеРеквизиты.Добавить("ФИОРуководителя");
	ПроверяемыеРеквизиты.Добавить("Организация");
	
	Для Каждого ПроверяемыйРеквизит Из ПроверяемыеРеквизиты Цикл
		Если Не ЗначениеЗаполнено(ЭтотОбъект[ПроверяемыйРеквизит]) Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;

КонецФункции

#КонецОбласти
