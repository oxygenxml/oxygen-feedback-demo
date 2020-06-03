package net.sf.xslthl.definition;

import net.sf.saxon.expr.XPathContext;
import net.sf.saxon.lib.ExtensionFunctionCall;
import net.sf.saxon.lib.ExtensionFunctionDefinition;
import net.sf.saxon.om.Item;
import net.sf.saxon.om.Sequence;
import net.sf.saxon.om.SequenceIterator;
import net.sf.saxon.om.StructuredQName;
import net.sf.saxon.trans.XPathException;
import net.sf.saxon.tree.iter.LookaheadIterator;
import net.sf.saxon.value.SequenceType;
import net.sf.xslthl.ConnectorSaxonEE;

public class HighlightFunctionDefinition extends ExtensionFunctionDefinition {

	/**
	 * Get the function QName
	 */
	@Override
	public StructuredQName getFunctionQName() {
	    return new StructuredQName(
	            "oxy", 
	            "http://www.oxygenxml.com/ns/author/xpath-extension-functions", 
	            "highlight");
	}

	/**
	 * 3 parameters:
	 * String hlCode, SequenceIterator seq, String configFilename
	 */
	@Override
	public SequenceType[] getArgumentTypes() {
		return new SequenceType[] {
				SequenceType.SINGLE_STRING, SequenceType.NODE_SEQUENCE, SequenceType.SINGLE_STRING 
		};
	}

	/**
	 * Result of type node sequence
	 */
	@Override
	public SequenceType getResultType(SequenceType[] suppliedArgumentTypes) {
		return SequenceType.NODE_SEQUENCE;
	}

	/**
	 * Call the Saxon EE connector.
	 */
	@Override
	public ExtensionFunctionCall makeCallExpression() {
		return new ExtensionFunctionCall() {
			
			@Override
			public Sequence call(XPathContext context, Sequence[] arguments) throws XPathException {
				try {
					//Call the connector, wrap the returned SequenceIterator in a Sequence.
					final SequenceIterator iter = ConnectorSaxonEE.highlight(context, arguments[0].head().getStringValue(), arguments[1].iterate(), arguments[2].head().getStringValue());
					return new Sequence() {
						//Try to somehow provide the head() and the next() without consuming items.
						private Item alreadyReadHead = null;
						private boolean firstNext = true;
						@Override
						public SequenceIterator iterate() throws XPathException {
						  
						  SequenceIterator wrapper = null;
						  
						  if (iter instanceof LookaheadIterator) {
						    wrapper = new LookaheadIterator() {
	                
	                @Override
	                public Item next() throws XPathException {
	                  if(firstNext) {
	                    if(alreadyReadHead == null) {
	                      alreadyReadHead = iter.next();
	                    }
	                    firstNext = false;
	                    return alreadyReadHead;
	                  }
	                  return iter.next();
	                }
	                
	                @Override
	                public int getProperties() {
	                  return iter.getProperties();
	                }
	                
	                @Override
	                public void close() {
	                  iter.close();
	                }
	                
	                @Override
	                public boolean hasNext() {
	                  return ((LookaheadIterator) iter).hasNext();
	                }
	              }; 
						  } else {
						      wrapper = new SequenceIterator() {
                    
                  @Override
                  public Item next() throws XPathException {
                    if(firstNext) {
                      if(alreadyReadHead == null) {
                        alreadyReadHead = iter.next();
                      }
                      firstNext = false;
                      return alreadyReadHead;
                    }
                    return iter.next();
                  }
                  
                  @Override
                  public int getProperties() {
                    return iter.getProperties();
                  }
                  
                  @Override
                  public void close() {
                    iter.close();
                  }
                  
                }; 
						  }
						  
							return wrapper;
						}
						
						@Override
						public Item head() throws XPathException {
							if(alreadyReadHead == null) {
								alreadyReadHead = iter.next(); 
							}
							return alreadyReadHead;
						}
					};
				} catch(XPathException e){
					throw e;
				} catch (Exception e) {
					throw new XPathException(e);
				}
			}
		};
	}

}
