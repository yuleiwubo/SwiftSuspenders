/*
* Copyright (c) 2009 the original author or authors
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

package org.swiftsuspenders.test.tests
{
	import mx.collections.ArrayCollection;
	
	import org.flexunit.Assert;
	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.test.support.injectees.ClassInjectee;
	import org.swiftsuspenders.test.support.injectees.InterfaceInjectee;
	import org.swiftsuspenders.test.support.injectees.MixedParametersConstructorInjectee;
	import org.swiftsuspenders.test.support.injectees.MixedParametersMethodInjectee;
	import org.swiftsuspenders.test.support.injectees.NamedArrayCollectionInjectee;
	import org.swiftsuspenders.test.support.injectees.NamedClassInjectee;
	import org.swiftsuspenders.test.support.injectees.NamedInterfaceInjectee;
	import org.swiftsuspenders.test.support.injectees.OneNamedParameterConstructorInjectee;
	import org.swiftsuspenders.test.support.injectees.OneNamedParameterMethodInjectee;
	import org.swiftsuspenders.test.support.injectees.OneParameterConstructorInjectee;
	import org.swiftsuspenders.test.support.injectees.OneParameterMethodInjectee;
	import org.swiftsuspenders.test.support.injectees.SetterInjectee;
	import org.swiftsuspenders.test.support.injectees.TwoNamedParametersConstructorInjectee;
	import org.swiftsuspenders.test.support.injectees.TwoNamedParametersMethodInjectee;
	import org.swiftsuspenders.test.support.injectees.TwoParametersConstructorInjectee;
	import org.swiftsuspenders.test.support.injectees.TwoParametersMethodInjectee;
	import org.swiftsuspenders.test.support.types.Clazz;
	import org.swiftsuspenders.test.support.types.Interface;
	
	public class SimpleInjectorTests
	{
		protected var injector:Injector;
		
		[Before]
		public function runBeforeEachTest():void
		{
			injector = new Injector();
		}
		
		[Test]
		public function unbind():void
		{
			var injectee:ClassInjectee = new ClassInjectee();
			var value:Clazz = new Clazz();
			injector.mapValue(Clazz, value);
			injector.unmap(Clazz);
			try
			{
				injector.injectInto(injectee);
			}
			catch(e:Error)
			{
			}
			Assert.assertEquals("Property should not be injected", null, injectee.property);
		}
		
		[Test]
		public function bindValue():void
		{
			var injectee:ClassInjectee = new ClassInjectee();
			var injectee2:ClassInjectee = new ClassInjectee();
			var value:Clazz = new Clazz();
			injector.mapValue(Clazz, value);
			injector.injectInto(injectee);
			Assert.assertStrictlyEquals("Value should have been injected", value, injectee.property );
			injector.injectInto(injectee2);
			Assert.assertStrictlyEquals("Injected values should be equal", injectee.property, injectee2.property );
		}
		
		[Test]
		public function bindValueByInterface():void
		{
			var injectee:InterfaceInjectee = new InterfaceInjectee();
			var value:Interface = new Clazz();
			injector.mapValue(Interface, value);
			injector.injectInto(injectee);
			Assert.assertStrictlyEquals("Value should have been injected", value, injectee.property );
		}
		
		[Test]
		public function bindNamedValue():void
		{
			var injectee:NamedClassInjectee = new NamedClassInjectee();
			var value:Clazz = new Clazz();
			injector.mapValue(Clazz, value, NamedClassInjectee.NAME);
			injector.injectInto(injectee);
			Assert.assertStrictlyEquals("Named value should have been injected", value, injectee.property );
		}
		
		[Test]
		public function bindNamedValueByInterface():void
		{
			var injectee:NamedInterfaceInjectee = new NamedInterfaceInjectee();
			var value:Interface = new Clazz();
			injector.mapValue(Interface, value, NamedClassInjectee.NAME);
			injector.injectInto(injectee);
			Assert.assertStrictlyEquals("Named value should have been injected", value, injectee.property );
		}
		
		[Test]
		public function bindClass():void
		{
			var injectee:ClassInjectee = new ClassInjectee();
			var injectee2:ClassInjectee = new ClassInjectee();
			injector.mapClass(Clazz, Clazz);
			injector.injectInto(injectee);
			Assert.assertNotNull("Instance of Class should have been injected", injectee.property );
			injector.injectInto(injectee2);
			Assert.assertFalse("Injected values should be different", injectee.property == injectee2.property );
		}
		
		[Test]
		public function bindClassByInterface():void
		{
			var injectee:InterfaceInjectee = new InterfaceInjectee();
			injector.mapClass(Interface, Clazz);
			injector.injectInto(injectee);
			Assert.assertNotNull("Instance of Class should have been injected", injectee.property );
		}
		
		[Test]
		public function bindNamedClass():void
		{
			var injectee:NamedClassInjectee = new NamedClassInjectee();
			injector.mapClass(Clazz, Clazz, NamedClassInjectee.NAME);
			injector.injectInto(injectee);
			Assert.assertNotNull("Instance of named Class should have been injected", injectee.property );
		}
		
		[Test]
		public function bindNamedClassByInterface():void
		{
			var injectee:NamedInterfaceInjectee = new NamedInterfaceInjectee();
			injector.mapClass(Interface, Clazz, NamedClassInjectee.NAME);
			injector.injectInto(injectee);
			Assert.assertNotNull("Instance of named Class should have been injected", injectee.property );
		}
		
		[Test]
		public function bindSingleton():void
		{
			var injectee:ClassInjectee = new ClassInjectee();
			var injectee2:ClassInjectee = new ClassInjectee();
			injector.mapSingleton(Clazz);
			injector.injectInto(injectee);
			Assert.assertNotNull("Instance of Class should have been injected", injectee.property );
			injector.injectInto(injectee2);
			Assert.assertStrictlyEquals("Injected values should be equal", injectee.property, injectee2.property );
		}
		
		[Test]
		public function bindSingletonOf():void
		{
			var injectee:InterfaceInjectee = new InterfaceInjectee();
			var injectee2:InterfaceInjectee = new InterfaceInjectee();
			injector.mapSingletonOf(Interface, Clazz);
			injector.injectInto(injectee);
			Assert.assertNotNull("Instance of Class should have been injected", injectee.property );
			injector.injectInto(injectee2);
			Assert.assertStrictlyEquals("Injected values should be equal", injectee.property, injectee2.property );
		}
		
		[Test]
		public function performSetterInjection():void
		{
			var injectee:SetterInjectee = new SetterInjectee();
			var injectee2:SetterInjectee = new SetterInjectee();
			injector.mapClass(Clazz, Clazz);
			injector.injectInto(injectee);
			Assert.assertNotNull("Instance of Class should have been injected", injectee.property );
			injector.injectInto(injectee2);
			Assert.assertFalse("Injected values should be different", injectee.property == injectee2.property );
		}
		
		[Test]
		public function performMethodInjectionWithOneParameter():void
		{
			var injectee:OneParameterMethodInjectee = new OneParameterMethodInjectee();
			var injectee2:OneParameterMethodInjectee = new OneParameterMethodInjectee();
			injector.mapClass(Clazz, Clazz);
			injector.injectInto(injectee);
			Assert.assertNotNull("Instance of Class should have been injected", injectee.getDependency() );
			injector.injectInto(injectee2);
			Assert.assertFalse("Injected values should be different", injectee.getDependency() == injectee2.getDependency() );
		}
		
		[Test]
		public function performMethodInjectionWithOneNamedParameter():void
		{
			var injectee:OneNamedParameterMethodInjectee = new OneNamedParameterMethodInjectee();
			var injectee2:OneNamedParameterMethodInjectee = new OneNamedParameterMethodInjectee();
			injector.mapClass(Clazz, Clazz, 'namedDep');
			injector.injectInto(injectee);
			Assert.assertNotNull("Instance of Class should have been injected for named Clazz parameter", injectee.getDependency() );
			injector.injectInto(injectee2);
			Assert.assertFalse("Injected values should be different", injectee.getDependency() == injectee2.getDependency() );
		}
		
		[Test]
		public function performMethodInjectionWithTwoParameters():void
		{
			var injectee:TwoParametersMethodInjectee = new TwoParametersMethodInjectee();
			var injectee2:TwoParametersMethodInjectee = new TwoParametersMethodInjectee();
			injector.mapClass(Clazz, Clazz);
			injector.mapClass(Interface, Clazz);
			injector.injectInto(injectee);
			Assert.assertNotNull("Instance of Class should have been injected for unnamed Clazz parameter", injectee.getDependency() );
			Assert.assertNotNull("Instance of Class should have been injected for unnamed Interface parameter", injectee.getDependency2() );
			injector.injectInto(injectee2);
			Assert.assertFalse("Injected values should be different", injectee.getDependency() == injectee2.getDependency() );
			Assert.assertFalse("Injected values for Interface should be different", injectee.getDependency2() == injectee2.getDependency2() );
		}
		
		[Test]
		public function performMethodInjectionWithTwoNamedParameters():void
		{
			var injectee:TwoNamedParametersMethodInjectee = new TwoNamedParametersMethodInjectee();
			var injectee2:TwoNamedParametersMethodInjectee = new TwoNamedParametersMethodInjectee();
			injector.mapClass(Clazz, Clazz, 'namedDep');
			injector.mapClass(Interface, Clazz, 'namedDep2');
			injector.injectInto(injectee);
			Assert.assertNotNull("Instance of Class should have been injected for named Clazz parameter", injectee.getDependency() );
			Assert.assertNotNull("Instance of Class should have been injected for  for named Interface parameter", injectee.getDependency2() );
			injector.injectInto(injectee2);
			Assert.assertFalse("Injected values should be different", injectee.getDependency() == injectee2.getDependency() );
			Assert.assertFalse("Injected values for Interface should be different", injectee.getDependency2() == injectee2.getDependency2() );
		}
		
		[Test]
		public function performMethodInjectionWithMixedParameters():void
		{
			var injectee:MixedParametersMethodInjectee = new MixedParametersMethodInjectee();
			var injectee2:MixedParametersMethodInjectee = new MixedParametersMethodInjectee();
			injector.mapClass(Clazz, Clazz, 'namedDep');
			injector.mapClass(Clazz, Clazz);
			injector.mapClass(Interface, Clazz, 'namedDep2');
			injector.injectInto(injectee);
			Assert.assertNotNull("Instance of Class should have been injected for named Clazz parameter", injectee.getDependency() );
			Assert.assertNotNull("Instance of Class should have been injected for unnamed Clazz parameter", injectee.getDependency2() );
			Assert.assertNotNull("Instance of Class should have been injected for Interface", injectee.getDependency3() );
			injector.injectInto(injectee2);
			Assert.assertFalse("Injected values for named Clazz should be different", injectee.getDependency() == injectee2.getDependency() );
			Assert.assertFalse("Injected values for unnamed Clazz should be different", injectee.getDependency2() == injectee2.getDependency2() );
			Assert.assertFalse("Injected values for named Interface should be different", injectee.getDependency3() == injectee2.getDependency3() );
		}
		
		[Test]
		public function performConstructorInjectionWithOneParameter():void
		{
			injector.mapClass(Clazz, Clazz);
			var injectee:OneParameterConstructorInjectee = injector.instantiate(OneParameterConstructorInjectee);
			Assert.assertNotNull("Instance of Class should have been injected for Clazz parameter", injectee.getDependency() );
		}
		
		[Test]
		public function performConstructorInjectionWithTwoParameters():void
		{
			injector.mapClass(Clazz, Clazz);
			injector.mapValue(String, 'stringDependency');
			var injectee:TwoParametersConstructorInjectee = injector.instantiate(TwoParametersConstructorInjectee);
			Assert.assertNotNull("Instance of Class should have been injected for named Clazz parameter", injectee.getDependency());
			Assert.assertEquals("The String 'stringDependency' should have been injected for String parameter", injectee.getDependency2(), 'stringDependency');
		}
		
		[Test]
		public function performConstructorInjectionWithOneNamedParameter():void
		{
			injector.mapClass(Clazz, Clazz, 'namedDependency');
			var injectee:OneNamedParameterConstructorInjectee = injector.instantiate(OneNamedParameterConstructorInjectee);
			Assert.assertNotNull("Instance of Class should have been injected for named Clazz parameter", injectee.getDependency() );
		}
		
		[Test]
		public function performConstructorInjectionWithTwoNamedParameter():void
		{
			injector.mapClass(Clazz, Clazz, 'namedDependency');
			injector.mapValue(String, 'stringDependency', 'namedDependency2');
			var injectee:TwoNamedParametersConstructorInjectee = injector.instantiate(TwoNamedParametersConstructorInjectee);
			Assert.assertNotNull("Instance of Class should have been injected for named Clazz parameter", injectee.getDependency());
			Assert.assertEquals("The String 'stringDependency' should have been injected for named String parameter", injectee.getDependency2(), 'stringDependency');
		}
		
		[Test]
		public function performConstructorInjectionWithMixedParameters():void
		{
			injector.mapClass(Clazz, Clazz, 'namedDep');
			injector.mapClass(Clazz, Clazz);
			injector.mapClass(Interface, Clazz, 'namedDep2');
			var injectee:MixedParametersConstructorInjectee = injector.instantiate(MixedParametersConstructorInjectee);
			Assert.assertNotNull("Instance of Class should have been injected for named Clazz parameter", injectee.getDependency() );
			Assert.assertNotNull("Instance of Class should have been injected for unnamed Clazz parameter", injectee.getDependency2() );
			Assert.assertNotNull("Instance of Class should have been injected for Interface", injectee.getDependency3() );
		}
		
		[Test]
		public function performNamedArrayInjection():void
		{
			var ac : ArrayCollection = new ArrayCollection();
			injector.mapValue(ArrayCollection, ac, "namedCollection");
			var injectee:NamedArrayCollectionInjectee = injector.instantiate(NamedArrayCollectionInjectee);
			Assert.assertNotNull("Instance 'ac' should have been injected for named ArrayCollection parameter", injectee.ac );
			Assert.assertEquals("Instance field 'ac' should be identical to local variable 'ac'", ac, injectee.ac);
		}
		
		[Test(expects="org.swiftsuspenders.InjectorError")]
		public function haltOnMissingDependency():void
		{
			var injectee:InterfaceInjectee = new InterfaceInjectee();
			injector.injectInto(injectee);
		}
		
	}
}