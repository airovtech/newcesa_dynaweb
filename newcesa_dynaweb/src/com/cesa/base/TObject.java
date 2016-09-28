package com.cesa.base;

/**
 * �ֻ��� Ŭ����<br>
 * ��� Ŭ������ TObject �� ��ӹ޵��� �Ѵ�.
 * 
 * @version 1.0
 * @author moon jong doek, 2008-10-22
 */
public class TObject {
	
	/**
	 * �⺻ ������
	 */
    public TObject() {
        super();
    }
    
    /**
	 * Ŭ������ �̸��� ��´�.
	 */
	private String _name = "";

	/**
	 * Ŭ���� �̸��� �����Ѵ�.
	 * @param String name
	 */
	public void _setName(String name) {
		this._name = name;
	}
	
	/**
	 * Ŭ���� �̸��� �����Ѵ�.
	 */
	public String _getName() {
		return this._name;
	}

	/**
	 * ��Ʈ������ �����Ѵ�.<br>
	 * ����� ��ӹ޾Ƽ� ������� Ŭ������ �̸��� ������ �����ϵ��� �Ѵ�.
	 */
	public String toString() {
		return _name;
	}
}
